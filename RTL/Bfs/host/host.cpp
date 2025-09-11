

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
// corresponding to the txt file
#define USED_NUM_HBM_CHANNEL 2
#define NUM_HBM_CHANNEL 2
// HBM Pseudo-channel(PC) requirements
#define MAX_HBM_PC_COUNT 32
#define PC_NAME(n) n | XCL_MEM_TOPOLOGY

/* ------------------------------ dataset config ------------------------------ */ 
// #define file_loc "/home/junshuang/project/accelerator/bfs_acc/data/"
// const int root_id = 3;
// const int vertex_num[USED_NUM_HBM_CHANNEL] = {4154, 4144};
// const int bitmap_compressed_num = 9;
// const int iteration_num = 6;

// #define file_loc "/home/junshuang/project/accelerator/bfs_acc/data_32_LG/"
// const int root_id = 1;
// const int vertex_num[USED_NUM_HBM_CHANNEL] = {8192, 8191};
// const int bitmap_compressed_num = 16;
// const int iteration_num = 6;

#define file_loc "/home/junshuang/Project/Benchmark/BFS/bfs_acc/data_rmat18/"
const int root_id = 4000;
const int vertex_num[USED_NUM_HBM_CHANNEL] = {131072, 131072};
const int edge_num = 8388608;
const int bitmap_compressed_num = 256;
const int iteration_num = 6;
/* ---------------------------------------------------------------------------- */

const float freq = 137.1;   // MHz, Use the "Vitis Analyzer" to open xxx_hw_link/Hardware/*.xclbin.link_summary

const int CORE_NUM = 32;
const int TOTAL_NUM_HBM_CHANNEL = USED_NUM_HBM_CHANNEL + USED_NUM_HBM_CHANNEL / 2 + 1;


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
    // char* f1("edge_channel_small_64_");
    // char* f2("edge_channel_small_64_");
    // std::string filename_base(f1);
    // std::string filename_end(f2);
    
    //   std::count(std::istreambuf_iterator<char>(inFile), 
    //          std::istreambuf_iterator<char>(), '\n');

    // std::ifstream is(filename,ios_base::in);
    // std::istream_iterator<unsigned int> 

    // unsigned int dataSize = 64 * 1024 * 1024; // taking maximum possible data size value for an HBM bank
    unsigned int dataSize[TOTAL_NUM_HBM_CHANNEL];
    const unsigned int mask_id=0xfffff; // 1024*1024:fffff, 16384:3fff
    const unsigned int mask_depth=0xff00000; // 1024*1024:ff00000,16384:3fc000
    for(int i = 0; i<USED_NUM_HBM_CHANNEL; i++)
    {
        // std::string filename(filename_base+std::to_string(i)+filename_end);
        std::string filename = std::string(file_loc) + "edge_channel_small_"+std::to_string(i)+".txt";
      std::ifstream is(filename);
      if (! is.is_open())
      {
        std::cout << "Error opening file: " << filename <<std::endl; exit (1);
      }
    //   is.open(filename,std::ios_base::in);
      dataSize[i]=std::count(std::istreambuf_iterator<char>(is), 
             std::istreambuf_iterator<char>(), '\n');
        is.close();
        // dataSize[i] = 2;
        std::cout << "DataSize:" <<dataSize[i] << std::endl;
    }
    // bitmap
    for (int i = 0; i < 1; i++) {
        std::string filename = std::string(file_loc) + "vis_bitmap_small_" + std::to_string(0) + ".mem";
        std::ifstream is(filename);
        if (!is.is_open()) {
            std::cout << "Error opening file: " << filename << std::endl; exit(1);
        }
        dataSize[USED_NUM_HBM_CHANNEL] = std::count(std::istreambuf_iterator<char>(is), std::istreambuf_iterator<char>(), '\n') * (CORE_NUM / 32); // 4 Bytes -> 32 bits
        is.close();
        std::cout << "bitmap DataSize: " << dataSize[USED_NUM_HBM_CHANNEL] << std::endl;
    }
    // first_edge
    for (int i = 0; i < USED_NUM_HBM_CHANNEL / 2; i++) {
        std::string filename = std::string(file_loc) + "first_edge_small_" + std::to_string(0) + ".mem";
        std::ifstream is(filename);
        if (!is.is_open()) {
            std::cout << "Error opening file: " << filename << std::endl; exit(1);
        }
        dataSize[USED_NUM_HBM_CHANNEL + i + 1] = std::count(std::istreambuf_iterator<char>(is), std::istreambuf_iterator<char>(), '\n') * 32; // 1 Channel -> 32 CORE -> 32 int
        is.close();
        std::cout << "first_edge DataSize: " << dataSize[USED_NUM_HBM_CHANNEL + i + 1] << std::endl;
    }

    bool test = false;

    // unsigned int num_times = 1024;            // num_times specify, number of times a kernel
                                              // will execute the same operation. This is
                                              // needed
    // to keep the kernel busy to test the actual bandwidth of all banks running
    // concurrently.

    // reducing the test data capacity to run faster in emulation mode
    // if (xcl::is_emulation()) {
    //     dataSize = 1024;
    //     num_times = 64;
    // }

    std::string binaryFile = argv[1];
    cl_int err;
    cl::CommandQueue q;
    std::string krnl_name = "rtl_kernel_wizard_0";
    std::vector<cl::Kernel> krnls(NUM_KERNEL);
    cl::Context context;
    std::vector<unsigned int, aligned_allocator<unsigned int> > source_in[TOTAL_NUM_HBM_CHANNEL];
    // std::vector<int, aligned_allocator<int> > source_in1(dataSize);
    // std::vector<int, aligned_allocator<int> > source_in2(dataSize);
    // std::vector<int, aligned_allocator<int> > source_sw_add_results(dataSize);
    // std::vector<int, aligned_allocator<int> > source_sw_mul_results(dataSize);

    // std::vector<unsigned int, aligned_allocator<unsigned int> > source_hw_results[NUM_HBM_CHANNEL];
    // std::vector<int, aligned_allocator<int> > source_hw_add_results[NUM_KERNEL];
    // std::vector<int, aligned_allocator<int> > source_hw_mul_results[NUM_KERNEL];

    for (int i = 0; i < TOTAL_NUM_HBM_CHANNEL; i++) {
        source_in[i].resize(dataSize[i]);
        std::cout << "soucer_in " << i << " size: " <<source_in[i].size() << std::endl;
    }

    // Create the test data
    // std::generate(source_in1.begin(), source_in1.end(), std::rand);
    // std::generate(source_in2.begin(), source_in2.end(), std::rand);
    // for (size_t i = 0; i < dataSize; i++) {
    //     source_sw_add_results[i] = source_in1[i] + source_in2[i];
    //     source_sw_mul_results[i] = source_in1[i] * source_in2[i];
    // }
    std::cout << "Loading the init files..." << std::endl;
    unsigned int data_t;
    for (int i = 0; i < USED_NUM_HBM_CHANNEL; i++) {
        std::string filename = std::string(file_loc) + "edge_channel_small_"+std::to_string(i)+".txt";
        std::ifstream is(filename);
        if (! is.is_open())
        {
            std::cout << "Error opening file"<<std::endl; exit (1);
        }
        for(int j = 0; j < (int)dataSize[i]; j++)
        {
            is >> data_t;
            source_in[i][j]=data_t;
            // display for manual check
            // if (j < 64) std::cout << j << ": " << source_in[i][j] << std::endl;
        }
        is.close();
    }
    std::cout << "   - edge_channel done." << std::endl;
    // TODO add new assignment when adding a new channel
    // bitmap
    std::ifstream bitmap_file[CORE_NUM];
    for (int i = 0; i < CORE_NUM; i++) {
        std::string filename = std::string(file_loc) + "vis_bitmap_small_" + std::to_string(i) + ".mem";
        bitmap_file[i].open(filename);
        if (!bitmap_file[i].is_open()) {
            std::cout << "Error opening file: " << filename << std::endl;   exit(1);
        }
        std::string firstLine;
        std::getline(bitmap_file[i], firstLine);
        // std::cout << "Skipped the first line: " << firstLine << std::endl;
        if (bitmap_file[i].fail())  std::cout << "Skip the Line 0 failed." << std::endl;
    }
    for (int n = 0; n < (int)(dataSize[USED_NUM_HBM_CHANNEL] / CORE_NUM / (CORE_NUM / 32)); n++) {
        for (int i = 0; i < CORE_NUM; i++) {
            for (int j = 0; j < CORE_NUM / 32; j++) {   // bitmap_compressed_length = CORE_NUM
                data_t = 0;
                for (int k = 0; k < 32; k++) {
                    // concat these single bits
                    int tmp;
                    bitmap_file[i] >> tmp;
                    data_t = data_t | (tmp << k);
                }
                // display for manual check
                // if (n < 2)  std::cout << std::dec << (n * (CORE_NUM * (CORE_NUM / 32)) + i * (CORE_NUM / 32) + j) << ": 0x" << std::hex << data_t << std::endl;
                source_in[USED_NUM_HBM_CHANNEL][n * (CORE_NUM * (CORE_NUM / 32)) + i * (CORE_NUM / 32) + j] = data_t;
            }
        }
    }
    for (int i = 0; i < CORE_NUM; i++) {
        bitmap_file[i].close();
    }
    std::cout << "   - bitmap done." << std::endl;
    // first_edge
    std::ifstream firstedge_file[CORE_NUM];
    for (int i = 0; i < CORE_NUM; i++) {
        std::string filename = std::string(file_loc) + "first_edge_small_" + std::to_string(i) + ".mem";
        firstedge_file[i].open(filename);
        if (!firstedge_file[i].is_open()) {
            std::cout << "Error opening file: " << filename << std::endl;   exit(1);
        }
        std::string firstLine;
        std::getline(firstedge_file[i], firstLine);
        if (firstedge_file[i].fail())   std::cout << "Skip the Line 0 failed." << std::endl;
    }
    // 1 Channel -> 32 CORE
    for (int channel_num = 0; channel_num < USED_NUM_HBM_CHANNEL / 2; channel_num++) {
        for (int n = 0; n < (int)(dataSize[channel_num + USED_NUM_HBM_CHANNEL + 1] / 32); n++) {
            for (int i = 0; i < 32; i++) {
                firstedge_file[channel_num * 32 + i] >> std::hex >> data_t;
                // display for manual check
                // if (n < 2)  std::cout << std::dec << (n * 32 + i) << ": 0x" << std::hex << data_t << std::dec << std::endl;
                source_in[channel_num + USED_NUM_HBM_CHANNEL + 1][n * 32 + i] = data_t;
            }
        }
    }
    for (int i = 0; i < CORE_NUM; i++) {
        firstedge_file[i].close();
    }
    std::cout << "   - first edge done." << std::endl;
    // unused channels
    // for(int i = TOTAL_NUM_HBM_CHANNEL; i<NUM_HBM_CHANNEL; i++)
    // {
    //     for(int j = 0; j < (int)dataSize[i]; j++)
    //     {
    //         source_in[i][j]=0;
    //     }
    // }
    // Initializing output vectors to zero
    // for (size_t i = 0; i < NUM_HBM_CHANNEL; i++) {
    //     std::fill(source_hw_results[i].begin(), source_hw_results[i].end(), 0);
    // }

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
                std::string krnl_name_full = krnl_name + ":{" + "rtl_kernel_wizard_0_" + cu_id + "}";
                // std::string krnl_name_full = krnl_name + ":{" + "acc_" + cu_id + "}";
                // std::string krnl_name_full = krnl_name ;

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
    std::vector<cl_mem_ext_ptr_t> BufExt(TOTAL_NUM_HBM_CHANNEL);
    // std::vector<cl_mem_ext_ptr_t> outBufExt(NUM_HBM_CHANNEL);

    std::vector<cl::Buffer> buffer_data(TOTAL_NUM_HBM_CHANNEL);
    // std::vector<cl::Buffer> buffer_output(NUM_HBM_CHANNEL);
    // std::vector<cl_mem_ext_ptr_t> inBufExt1(NUM_KERNEL);
    // std::vector<cl_mem_ext_ptr_t> inBufExt2(NUM_KERNEL);
    // std::vector<cl_mem_ext_ptr_t> outAddBufExt(NUM_KERNEL);
    // std::vector<cl_mem_ext_ptr_t> outMulBufExt(NUM_KERNEL);

    // std::vector<cl::Buffer> buffer_input1(NUM_KERNEL);
    // std::vector<cl::Buffer> buffer_input2(NUM_KERNEL);
    // std::vector<cl::Buffer> buffer_output_add(NUM_KERNEL);
    // std::vector<cl::Buffer> buffer_output_mul(NUM_KERNEL);

    // For Allocating Buffer to specific Global Memory PC, user has to use
    // cl_mem_ext_ptr_t
    // and provide the PCs
    std::cout << "Allocating shared memory." << std::endl;
    for (int i = 0; i < TOTAL_NUM_HBM_CHANNEL; i++) {
        BufExt[i].obj = source_in[i].data();
        BufExt[i].param = 0;
        BufExt[i].flags = pc[i * (32 / (TOTAL_NUM_HBM_CHANNEL - 1))];
        std::cout << "Channel " << i << " attatched with PC" << (i * (32 / (TOTAL_NUM_HBM_CHANNEL - 1))) << std::endl;
        // display for manual check
        for (int j = 0; j < 32; j++) {
            std::cout << "Address " << j << ": " << source_in[i][j] << std::endl;
        }
    }

    // These commands will allocate memory on the FPGA. The cl::Buffer objects can
    // be used to reference the memory locations on the device.
    // Creating Buffers
    for (int i = 0; i < TOTAL_NUM_HBM_CHANNEL; i++) {
        OCL_CHECK(err,
                  buffer_data[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX | CL_MEM_USE_HOST_PTR,
                                                sizeof(uint32_t) * dataSize[i], &BufExt[i], &err));
    }

    // Copy input data to Device Global Memory
    // for (int i = 0; i < NUM_KERNEL; i++) {
    //     OCL_CHECK(err,
    //               err = q.enqueueMigrateMemObjects({buffer_input1[i], buffer_input2[i]}, 0 /* 0 means from host*/));
    // }
    // std::vector<cl::Memory> mems(NUM_HBM_CHANNEL);
    // for(int i=0;i<NUM_HBM_CHANNEL;i++)
    // {
    //     mems[i]=
    //     OCL_CHECK(err, mems[i] = cl::Buffer(context, (cl_mem_flags)(CL_MEM_READ_WRITE), nxtcnt, nullptr, &err));
    // }
    // OCL_CHECK(err,
    //           err = q.enqueueMigrateMemObjects(buffer_data, 0 /* 0 means from host*/));
    std::cout << "Transfering initialization data." << std::endl;
    cl::vector<cl::Memory> buffer_mem;
    for (int i = 0; i < TOTAL_NUM_HBM_CHANNEL; i++)
    {
        buffer_mem.push_back(buffer_data[i]);
    }
    for (int i = 0; i < NUM_KERNEL; i++) {
        OCL_CHECK(err,
                  err = q.enqueueMigrateMemObjects(buffer_mem, 0 /* 0 means from host*/));
    }
    q.finish();
    std::cout << "Transfering done."<<std::endl;
    double kernel_time_in_sec = 0, result = 0;

    std::chrono::duration<double> kernel_time(0);

    auto kernel_start = std::chrono::high_resolution_clock::now();
    OCL_CHECK(err, err = krnls[0].setArg(0, root_id));    // root_id
    OCL_CHECK(err, err = krnls[0].setArg(1, vertex_num[0] + vertex_num[1]));    // (vertex_num)
    OCL_CHECK(err, err = krnls[0].setArg(2, bitmap_compressed_num));   // bitmap_compressed_num
    OCL_CHECK(err, err = krnls[0].setArg(3, iteration_num));    // (iteration_num)
    // powerlaw_vertex_id
    std::string pl_file = std::string(file_loc) + "power_law.txt";
    std::ifstream pl(pl_file);
    if (!pl.is_open()) {
        fprintf(stderr, "Error opening file: %s, using default value.\n", pl_file.c_str());
        for (int i = 0; i < 32; i++)    OCL_CHECK(err, err = krnls[0].setArg(i+4, 65535+i));
    }
    else {
        for (int i = 0; i < 32; i++) {
            unsigned int pl_id;
            pl >> pl_id;
            OCL_CHECK(err, err = krnls[0].setArg(i+4, pl_id));
            fprintf(stdout, "Set Power law vertex[%d] = %d\n", i, pl_id);
        }
        pl.close();
    }
    // axi_ptr
    for (int i = 0; i < TOTAL_NUM_HBM_CHANNEL; i++) {
        // Setting the k_vadd Arguments
        OCL_CHECK(err, err = krnls[0].setArg(i+36, buffer_data[i]));
        // OCL_CHECK(err, err = krnls[0].setArg(1, buffer_input2[i]));
        // OCL_CHECK(err, err = krnls[0].setArg(2, buffer_output_add[i]));
        // OCL_CHECK(err, err = krnls[0].setArg(3, buffer_output_mul[i]));
        // OCL_CHECK(err, err = krnls[0].setArg(4, dataSize));
        // OCL_CHECK(err, err = krnls[0].setArg(5, num_times));

        // Invoking the kernel
        
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

    // std::vector<  >
    std::cout << "kernel end"<<std::endl;
    for (int i = 0; i < NUM_KERNEL; i++) {
        OCL_CHECK(err, err = q.enqueueMigrateMemObjects(buffer_mem,
                                                        CL_MIGRATE_MEM_OBJECT_HOST));
    }
    // OCL_CHECK(err, err = q.enqueueMigrateMemObjects(buffer_data,CL_MIGRATE_MEM_OBJECT_HOST));
    std::cout << "read back"<<std::endl;
    q.finish();

    // bool match = true;
    for(int i =16;i<100;i++)
    {
        std::bitset<32> data_bit(source_in[0][i]);
        std::cout <<"id:"<< (source_in[0][i]&mask_id) << "\tdepth:"<< ((source_in[0][i]&mask_depth)>>20) << "\tbits:" << data_bit << std::endl;
    }
    if( !test ){
        printf("Writing back the result to FOLDER %s\n", file_loc);
        for(int i = 0; i<USED_NUM_HBM_CHANNEL; i++){
            std::string filename = std::string(file_loc) + "hw_emulation_result_channel"+std::to_string(i)+".txt";
            std::ofstream os(filename);
            if(!os.is_open()){
                std::cout << "Error opening result file"<<std::endl; exit (1);
            }
            
            for(int j = 16; j<( vertex_num[i] + 16) ; j++){
                os << (source_in[i][j]&mask_id) << "\t" << ((source_in[i][j]&mask_depth)>>20) << "\n";
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
    std::cout << "Core active cycle number: " << source_in[0][0] << ", Freq = " << freq << "MHz" << std::endl;
    std::cout << "Performance: " << (edge_num / (source_in[0][0] / freq) / 1000) << "GTEPs" << std::endl;
    std::cout << "VITIS_TIME = " << kernel_time_in_sec << "s." << std::endl;
    // // OPENCL HOST CODE AREA ENDS

    // std::cout << (match ? "TEST PASSED" : "TEST FAILED") << std::endl;
    return EXIT_SUCCESS;
    // return (match ? EXIT_SUCCESS : EXIT_FAILURE);
}
