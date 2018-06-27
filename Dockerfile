FROM nvidia/opengl:1.0-glvnd-devel-ubuntu14.04

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
    tzdata \
    lsb-release \
    gnupg \
 && ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get clean

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
 && apt-get update \
 && apt-get install -y \
    ros-indigo-desktop-full \
 && rosdep init \
 && apt-get clean

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-indigo-catkin

RUN rm -rf /var/lib/apt/lists

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh	

RUN apt-get update && apt-get install -y \
	build-essential software-properties-common \
	libgoogle-glog-dev \
	&& rm -rf /var/lib/apt/lists	

RUN source /opt/ros/indigo/setup.bash \
	&& mkdir -p $CATKIN_WS/src \
	&& cd $CATKIN_WS && catkin_init_workspace \
	&& cd src && git clone https://github.com/ICRA2017/atom_mapping.git
	
RUN source /opt/ros/indigo/setup.bash \
	&& cd $CATKIN_WS/src/atom_mapping/internal \
	&& catkin_make -DCMAKE_BUILD_TYPE=Release

RUN source /opt/ros/indigo/setup.bash \
	&& git clone https://bitbucket.org/gtborg/gtsam.git \
	&& cd gtsam && mkdir build && cd build \
	&& cmake .. && make install
	
RUN source /opt/ros/indigo/setup.bash \
	&& git clone https://github.com/erik-nelson/blam.git \
	&& cd blam && ./update

RUN apt-get update && apt-get install -y \
	ros-indigo-rviz \
	&& rm -rf /var/lib/apt/lists	

