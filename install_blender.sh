#before running, make sure that install_deps.diff is located in ~/, or you can change its path below...

mkdir ~/blender-git
cd ~/blender-git
git clone https://git.blender.org/blender.git
cd blender
git submodule update --init --recursive
git submodule foreach git checkout master
git submodule foreach git pull --rebase origin master

# installing additional modules
sudo apt-get update; sudo apt-get install git build-essential
sudo apt-get install cmake cmake-curses-gui -y
sudo apt-get install libboost-all-dev openjpeg-tools libalut-dev libjemalloc-dev libspnav-dev libopenimageio-dev libosl-dev -y


# change the install_deps.h file:
# may need to change the file path
git apply ~/install_deps.diff


# get python paths
PYV=`python -c "import sys;t='{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)";`
PYTHON_PATH=`which python`
PYTHON_LIBRARY_PATH="${PYTHON_PATH}${PYV}m"
PYTHON_INCLUDE_PATH="${PYTHON_PATH%/*}/../include/python${PYV}m"

# Building from a custom cmake file:
./build_files/build_environment/install_deps.sh

# if you get the following error: No rule to make target '/usr/lib/x86_64-linux-gnu/libGL.so', needed by 'lib/libosdGPU.so.3.0.0'.
# follow the instructions here: https://github.com/RobotLocomotion/drake/issues/2087

mkdir ~/blender-git/build
cd ~/blender-git/build
cmake ../blender -DWITH_PYTHON_INSTALL=OFF -DWITH_PLAYER=OFF -DWITH_PYTHON_MODULE=ON -DPYTHON_LIBRARY=${PYTHON_LIBRARY_PATH} -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_PATH} -DWITH_MOD_SMOKE=OFF -DWITH_OPENCOLORIO=ON -DWITH_CYCLES_OSL=ON -DWITH_LLVM=ON -DLLVM_ROOT_DIR=/opt/lib/llvm
make -j10 	# number should be at most the number of cpu cores
make install


# verify installation
if [ -d ~/blender-git/build/bin ]; then
  echo "blender succesfully compiled!"
else
  echo "blender didn't compile correctly"
  exit 1
fi

# add dir to python_path
# if you're using pycharm, you may need to add this path manually
echo "export PYTHONPATH=\"\${PYTHONPATH}:~/blender-git/build/bin:\" " >> ~/.bashrc
