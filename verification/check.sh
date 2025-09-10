export VERIFICATION_TOOL_PATH=`pwd`
export TOOLS_PATH=${VERIFICATION_TOOL_PATH}/../tools
export GRAPH500_REFERENCE_PATH=${VERIFICATION_TOOL_PATH}/../tools/graph500-newreference

build_graph500_reference() {
	cd ${GRAPH500_REFERENCE_PATH}/src
	make
	cd -
}

build_verification() {
	cd ${VERIFICATION_TOOL_PATH}
	rm -rf ./build
	mkdir build
	cd build
	cmake ..
	make
	cd ..
}

store_graph_19() {
	export TMPFILE=${GRAPH500_REFERENCE_PATH}/data/graph_19
	export REUSEFILE=1
	cd ${GRAPH500_REFERENCE_PATH}/src
	./graph500_reference_bfs 19
	cd -
}

check_graph_19() {
	build_graph500_reference
	build_verification
	store_graph_19
	cd ${VERIFICATION_TOOL_PATH}
	mkdir -p data
	cd build 
	./main_test
}

check_graph_19