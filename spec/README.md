#### SPEC2006 Configuration files

This folder contains two .cfg files that I used for our experimentation.
There are two files - `linux64-amd64-clang-template-o3-400.perlbench.cfg` and 
`linux64-amd64-clang-template-o3.cfg`. For use, please modify `CC` and `CXX` variable to
appropriate clang paths.
They are derived from one of SPEC2006's basic configuration - `Example-linux64-amd64-gcc43+.cfg`.

Note : Among 19 SPEC benchmarks, `400.perlbench` should be built with
`linux64-amd64-clang-template-o3-400.perlbench.cfg`
because it requires special compilation flag for successful linking using clang.
For other bench marks, use `linux64-amd64-clang-template-o3.cfg`.
