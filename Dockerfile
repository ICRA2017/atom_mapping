FROM ros:indigo-perception

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-indigo-catkin \
	&& rm -rf /var/lib/apt/lists

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh	

RUN apt-get update && apt-get install -y \
	build-essential software-properties-common \
	libgoogle-glog-dev \
	&& rm -rf /var/lib/apt/lists	

RUN source /ros_entrypoint.sh \
	&& mkdir -p $CATKIN_WS/src \
	&& cd $CATKIN_WS && catkin_init_workspace \
	&& cd src && git clone https://github.com/ICRA2017/atom_mapping.git
	
RUN source /ros_entrypoint.sh \
	&& cd $CATKIN_WS/src/atom_mapping/internal \
	&& catkin_make -DCMAKE_BUILD_TYPE=Release

RUN source /ros_entrypoint.sh \
	&& git clone https://bitbucket.org/gtborg/gtsam.git \
	&& cd gtsam && mkdir build && cd build \
	&& cmake .. && make install
	
RUN source /ros_entrypoint.sh \
	&& git clone https://github.com/erik-nelson/blam.git \
	&& cd blam && ./update

RUN apt-get update && apt-get install -y \
	ros-indigo-rviz \
	&& rm -rf /var/lib/apt/lists	

