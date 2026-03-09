class DressGraph < Formula
  desc "DRESS edge similarity for graphs — C/C++ library"
  homepage "https://github.com/velicast/dress-graph"
  url "https://github.com/velicast/dress-graph/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "348cd3e15f3f9f6815e21b7550c2cdd7d7bd0d4e953b7c294c99cd15396797bf"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           *std_cmake_args,
           "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dress/dress.h>
      #include <stdio.h>
      int main() {
        int U[] = {0, 1, 2};
        int V[] = {1, 2, 0};
        p_dress_graph_t g = init_dress_graph(3, 3, U, V, NULL, 0, 0);
        if (!g) return 1;
        printf("OK\\n");
        free_dress_graph(g);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldress", "-lm", "-o", "test"
    assert_match "OK", shell_output("./test")
  end
end
