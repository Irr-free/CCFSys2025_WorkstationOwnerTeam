

#include <algorithm>
#include <iostream>
#include <fstream>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <bitset>

#include "xcl2.hpp"

#define NUM_KERNEL 1
#define USED_NUM_HBM_CHANNEL 2
#define NUM_HBM_CHANNEL 2
// HBM Pseudo-channel(PC) requirements
#define MAX_HBM_PC_COUNT 32
#define PC_NAME(n) n | XCL_MEM_TOPOLOGY

/* ------------------------------ dataset config ------------------------------ */ 
#define file_loc "/home/junshuang/project/accelerator/Delta_PageRank/pr_acc/data_16384/"
const int one_over_n    = 0x3880029a;
const int added_const   = 0x37199cb8;
const int delta2_value  = 0xb85999ba;
const int bitmap_compressed_num = 16;
const int vertex_num[2] = {8192, 8175};
const int offset[2] = {16, 16};

// #define file_loc "/home/junshuang/project/accelerator/Delta_PageRank/pr_acc/data_131073/"
// const int one_over_n    = 0x36FFFF80;
// const int added_const   = 0x3599994D;
// const int delta2_value  = 0xB6D9992D;
// const int bitmap_compressed_num = 129;
// const int vertex_num[2] = {65537, 65536};
// const int offset[2] = {16, 0};  // don't know why
/* ---------------------------------------------------------------------------- */

const int port[NUM_HBM_CHANNEL] = {0, 16};

const int pc[MAX_HBM_PC_COUNT] = {
    PC_NAME(0),  PC_NAME(1),  PC_NAME(2),  PC_NAME(3),  PC_NAME(4),  PC_NAME(5),  PC_NAME(6),  PC_NAME(7),
    PC_NAME(8),  PC_NAME(9),  PC_NAME(10), PC_NAME(11), PC_NAME(12), PC_NAME(13), PC_NAME(14), PC_NAME(15),
    PC_NAME(16),  PC_NAME(17),  PC_NAME(18),  PC_NAME(19),  PC_NAME(20),  PC_NAME(21),  PC_NAME(22),  PC_NAME(23),
    PC_NAME(24),  PC_NAME(25),  PC_NAME(26), PC_NAME(27), PC_NAME(28), PC_NAME(29), PC_NAME(30), PC_NAME(31)
    };

// Function for verifying results
// bool verify(std::vector<int, aligned_allocator<int> >& source_sw_add_results,
//             std::vector<int, aligned_allocator<int> >& source_sw_mul_results,
//             std::vector<int, aligned_allocator<int> >& source_hw_add_results,
//             std::vector<int, aligned_allocator<int> >& source_hw_mul_results,
//             unsigned int size) {
//     bool check = true;
//     for (size_t i = 0; i < size; i++) {
//         if (source_hw_add_results[i] != source_sw_add_results[i]) {
//             std::cout << "Error: Result mismatch in Addition Operation" << std::endl;
//             std::cout << "i = " << i << " CPU result = " << source_sw_add_results[i]
//                       << " Device result = " << source_hw_add_results[i] << std::endl;
//             check = false;
//             break;
//         }
//         if (source_hw_mul_results[i] != source_sw_mul_results[i]) {
//             std::cout << "Error: Result mismatch in Multiplication Operation" << std::endl;
//             std::cout << "i = " << i << " CPU result = " << source_sw_mul_results[i]
//                       << " Device result = " << source_hw_mul_results[i] << std::endl;
//             check = false;
//             break;
//         }
//     }
//     return check;
// }
void wait_for_enter(const std::string &msg) {
    std::cout << msg << std::endl;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <XCLBIN> \n", argv[0]);
        return -1;
    }

    // unsigned int dataSize = 64 * 1024 * 1024; // taking maximum possible data size value for an HBM bank
    unsigned int dataSize[NUM_HBM_CHANNEL];
    for(int i = 0; i<USED_NUM_HBM_CHANNEL; i++)
    {
        std::string filename = std::string(file_loc) + "edge_channel_small_"+std::to_string(i)+".txt";
        std::ifstream is(filename);
        if (! is.is_open())
        {
            std::cout << "Error opening file"<<std::endl; exit (1);
        }
        dataSize[i]=std::count(std::istreambuf_iterator<char>(is), 
             std::istreambuf_iterator<char>(), '\n');
        is.close();
        std::cout << "DataSize:" <<dataSize[i] << std::endl;
    }

    bool test = false;

    std::string binaryFile = argv[1];
    cl_int err;
    cl::CommandQueue q;
    // CHECK change the name according to RTL kernel name
    // std::string krnl_name = "rtl_kernel_wizard_0";
    std::string krnl_name = "pr_kernel";
    std::vector<cl::Kernel> krnls(NUM_KERNEL);
    cl::Context context;
    std::vector<unsigned int, aligned_allocator<unsigned int> > source_in[NUM_HBM_CHANNEL];

    for (int i = 0; i < NUM_HBM_CHANNEL; i++) {
        source_in[i].resize(dataSize[i]);
    }

    unsigned int data_t;
    for (int i = 0; i < USED_NUM_HBM_CHANNEL; i++) {
        std::string filename= std::string(file_loc) + "edge_channel_small_"+std::to_string(i)+".txt";
        std::ifstream is(filename);
        if (! is.is_open())
        {
            std::cout << "Error opening file"<<std::endl; exit (1);
        }
        for(int j = 0; j < (int)dataSize[i]; j++)
        {
            is >> data_t;
            source_in[i][j]=data_t;
        }
    }
    for(int i = USED_NUM_HBM_CHANNEL; i<NUM_HBM_CHANNEL; i++)
    {
        for(int j = 0; j < (int)dataSize[i]; j++)
        {
            source_in[i][j]=0;
        }
    }

    // OPENCL HOST CODE AREA START
    // The get_xil_devices will return vector of Xilinx Devices
    auto devices = xcl::get_xil_devices();

    // read_binary_file() command will find the OpenCL binary file created using
    // the
    // V++ compiler load into OpenCL Binary and return pointer to file buffer.
    auto fileBuf = xcl::read_binary_file(binaryFile);

    cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
    bool valid_device = false;
    for (unsigned int i = 0; i < devices.size(); i++) {
        auto device = devices[i];
        // Creating Context and Command Queue for selected Device
        OCL_CHECK(err, context = cl::Context(device, nullptr, nullptr, nullptr, &err));
        OCL_CHECK(err, q = cl::CommandQueue(context, device,
                                            CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE | CL_QUEUE_PROFILING_ENABLE, &err));

        std::cout << "Trying to program device[" << i << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;
        cl::Program program(context, {device}, bins, nullptr, &err);
        if (err != CL_SUCCESS) {
            std::cout << "Failed to program device[" << i << "] with xclbin file!\n";
        } else {
            std::cout << "Device[" << i << "]: program successful!\n";
            // Creating Kernel object using Compute unit names

            for (int i = 0; i < NUM_KERNEL; i++) {
                std::string cu_id = std::to_string(i + 1);
                // CHECK change the kernel name according to RTL kernel name
                // std::string krnl_name_full = krnl_name + ":{" + "rtl_kernel_wizard_0_" + cu_id + "}";
                std::string krnl_name_full = krnl_name + ":{" + "pr_kernel_" + cu_id + "}";

                printf("Creating a kernel [%s] for CU(%d)\n", krnl_name_full.c_str(), i + 1);

                // Here Kernel object is created by specifying kernel name along with
                // compute unit.
                // For such case, this kernel object can only access the specific
                // Compute unit

                OCL_CHECK(err, krnls[i] = cl::Kernel(program, krnl_name_full.c_str(), &err));
            }
            valid_device = true;
            break; // we break because we found a valid device
        }
    }
    if (!valid_device) {
        std::cout << "Failed to program any device found, exit!\n";
        exit(EXIT_FAILURE);
    }
    std::vector<cl_mem_ext_ptr_t> BufExt(NUM_HBM_CHANNEL);

    std::vector<cl::Buffer> buffer_data(NUM_HBM_CHANNEL);

    // For Allocating Buffer to specific Global Memory PC, user has to use
    // cl_mem_ext_ptr_t
    // and provide the PCs
    for (int i = 0; i < NUM_HBM_CHANNEL; i++) {
        BufExt[i].obj = source_in[i].data();
        BufExt[i].param = 0;
        BufExt[i].flags = pc[port[i]];
    }

    // These commands will allocate memory on the FPGA. The cl::Buffer objects can
    // be used to reference the memory locations on the device.
    // Creating Buffers
    for (int i = 0; i < NUM_HBM_CHANNEL; i++) {
        OCL_CHECK(err,
                  buffer_data[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX | CL_MEM_USE_HOST_PTR,
                                                sizeof(uint32_t) * dataSize[i], &BufExt[i], &err));
    }

    // Copy input data to Device Global Memory
    cl::vector<cl::Memory> buffer_mem;
    for (int i = 0; i < NUM_HBM_CHANNEL; i++)
    {
        buffer_mem.push_back(buffer_data[i]);
    }
    for (int i = 0; i < NUM_KERNEL; i++) {
        OCL_CHECK(err,
                  err = q.enqueueMigrateMemObjects(buffer_mem, 0 /* 0 means from host*/));
    }
    q.finish();
    std::cout << "write data"<<std::endl;
    double kernel_time_in_sec = 0, result = 0;

    std::chrono::duration<double> kernel_time(0);

    auto kernel_start = std::chrono::high_resolution_clock::now();
    OCL_CHECK(err, err = krnls[0].setArg(0, one_over_n));       // one_over_n   -> 1.0 / vertex_num
    OCL_CHECK(err, err = krnls[0].setArg(1, added_const));      // added_const  -> (1 - damping) * one_over_n, damping = 0.85
    OCL_CHECK(err, err = krnls[0].setArg(2, delta2_value));     // delta2_value -> added_const - one_over_n
    OCL_CHECK(err, err = krnls[0].setArg(3, bitmap_compressed_num));    // bitmap_compressed_num
    for (int i = 0; i < NUM_HBM_CHANNEL; i++) {
        OCL_CHECK(err, err = krnls[0].setArg(i+4, buffer_data[i]));
    }
    std::cout << "set arg"<<std::endl;
    wait_for_enter("\nPress ENTER to continue after setting up ILA trigger...");
    OCL_CHECK(err, err = q.enqueueTask(krnls[0]));
    std::cout << "kernel start"<<std::endl;
    q.finish();
    auto kernel_end = std::chrono::high_resolution_clock::now();

    kernel_time = std::chrono::duration<double>(kernel_end - kernel_start);

    kernel_time_in_sec = kernel_time.count();
    // kernel_time_in_sec /= NUM_KERNEL;
    
    // Copy Result from Device Global Memory to Host Local Memory
    std::cout << "kernel end"<<std::endl;
    for (int i = 0; i < NUM_KERNEL; i++) {
        OCL_CHECK(err, err = q.enqueueMigrateMemObjects(buffer_mem,
                                                        CL_MIGRATE_MEM_OBJECT_HOST));
    }
    std::cout << "read back"<<std::endl;
    q.finish();

    // bool match = true;
    // for(int i=0;i<NUM_HBM_CHANNEL;i++)
    // {
    //     for(int j=0;j<)
    // }
    for (int i = 0; i < 16; i++)
    {
        std::cout <<source_in[0][i]<<std::endl;
    }
    for(int i =16;i<100;i++)
    {
        std::bitset<32> data_bit(source_in[0][i]);
        std::cout <<"id:" << std::dec << (i-16) << "\tvalue:"<< std::hex << source_in[0][i] << "\tbits:" << data_bit << std::endl;
    }
    if( !test ){
        printf("write back result\n");
        for(int i = 0; i<USED_NUM_HBM_CHANNEL; i++){
            std::string filename = std::string(file_loc) + "hw_emulation_result_channel"+std::to_string(i)+".txt";
            std::ofstream os(filename);
            if(!os.is_open()){
                std::cout << "Error opening result file"<<std::endl; exit (1);
            }
            float tmp;
            for(int j = offset[i]; j<( vertex_num[i] + offset[i]) ; j++){
                memcpy(&tmp, &source_in[i][j], sizeof(float));
                os << std::fixed << tmp << "\n";
            }
        }
    }
    

    // for (int i = 0; i < NUM_KERNEL; i++) {
    //     match = verify(source_sw_add_results, source_sw_mul_results, source_hw_add_results[i], source_hw_mul_results[i],
    //                    dataSize);
    // }

    // // Multiplying the actual data size by 4 because four buffers are being used.
    // result = 4 * (float)dataSize * num_times * sizeof(uint32_t);
    // result /= 1000;               // to KB
    // result /= 1000;               // to MB
    // result /= 1000;               // to GB
    // result /= kernel_time_in_sec; // to GBps

    // std::cout << "THROUGHPUT = " << result << " GB/s" << std::endl;
    std::cout << "VITIS_TIME = " << kernel_time_in_sec << std::endl;
    // // OPENCL HOST CODE AREA ENDS

    // std::cout << (match ? "TEST PASSED" : "TEST FAILED") << std::endl;
    return EXIT_SUCCESS;
    // return (match ? EXIT_SUCCESS : EXIT_FAILURE);
}
