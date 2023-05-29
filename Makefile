.PHONY: compile
compile:
	g++ -c -Wall -Wextra -g -Ivendor/glad/include -Ivendor/glfw/include -Ivendor/KTX-Software/include src/main.cpp -o src/main.o
	g++ src/main.o -Lvendor/glad/build -l:libglad.a -Lvendor/glfw/build -l:src/libglfw3.a -Lvendor/KTX-Software/build -l:libktx.a -o main-bin  -lpthread -ldl

prepare: fetch-submodules build-glad build-glfw build-ktx

fetch-submodules:
	git submodule update --init --recursive

build-glad:
	rm -rf vendor/glad/build
	mkdir vendor/glad/build
	gcc -O2 -c vendor/glad/src/gl.c -Ivendor/glad/include -o vendor/glad/build/glad.o
	ar rcs vendor/glad/build/libglad.a vendor/glad/build/glad.o

build-glfw:
	rm -rf vendor/glfw/build
	mkdir vendor/glfw/build
	cd vendor/glfw/build && cmake .. && make

build-ktx:
	rm -rf vendor/KTX-Software/build
	mkdir vendor/KTX-Software/build
	cd vendor/KTX-Software/build && \
cmake .. -DCMAKE_CXX_FLAGS="-Wno-error=dangling-reference" -DCMAKE_C_FLAGS="-Wno-error=dangling-reference" \
-DKTX_FEATURE_STATIC_LIBRARY=ON -DCMAKE_BUILD_TYPE=Release -DKTX_FEATURE_VULKAN=OFF && \
make
