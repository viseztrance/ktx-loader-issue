#include <iostream>

#include "glad/gl.h"
#include "GLFW/glfw3.h"
#define KHRONOS_STATIC
#include "ktx.h"

int main() {
    glfwInit();

    GLFWwindow* window = glfwCreateWindow(800, 600, "Test", nullptr, nullptr);

    if (window == nullptr) {
        glfwTerminate();
        return -1;
    }

    glfwMakeContextCurrent(window);
    int version = gladLoadGL(glfwGetProcAddress);
    if (version == 0) {
        std::cerr << "Failed to initialize OpenGL context" << std::endl;
    }

    ktxTexture* kTexture;
    KTX_error_code result;
    GLenum target;

    result = ktxTexture_CreateFromNamedFile("texture.ktx", KTX_TEXTURE_CREATE_LOAD_IMAGE_DATA_BIT, &kTexture);
    GLuint texture;
    result = ktxTexture_GLUpload(kTexture, &texture, &target, nullptr);

    while (!glfwWindowShouldClose(window)) {

        glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(target, texture);

        glfwSwapBuffers(window);

        glfwPollEvents();
    }

    glfwTerminate();

    return 0;
}
