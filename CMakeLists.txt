cmake_minimum_required(VERSION 3.5)
project(fixposition_gnss_tf LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=always -Wall -Wextra -Wpedantic -Wno-unused-parameter")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
add_definitions(-DEIGEN_DISABLE_UNALIGNED_ARRAY_ASSERT)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
)
find_package(Eigen3 REQUIRED)

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if your package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
  INCLUDE_DIRS include
  LIBRARIES ${PROJECT_NAME}
  CATKIN_DEPENDS roscpp
)

###########
## Build ##
###########

## Specify additional locations of header files
## Your package locations should be listed before other locations
include_directories(
 include
  ${catkin_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIR}
)

add_library(
  ${PROJECT_NAME}
    src/gnss_tf.cpp
)

target_link_libraries(${PROJECT_NAME}
  ${catkin_LIBRARIES}
  ${EIGEN3_LIBRARIES}
)


#############
## Install ##
#############

# all install targets should use catkin DESTINATION variables
# See http://ros.org/doc/api/catkin/html/adv_user_guide/variables.html

## Mark executables and/or libraries for installation
install(
  TARGETS
    ${PROJECT_NAME}
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

## Mark cpp header files for installation
install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)

#############
## Testing ##
#############

if (CATKIN_ENABLE_TESTING)
  find_package(yaml-cpp  REQUIRED)

  catkin_add_gtest(gnss_test test/gnss_test.cpp)
  target_compile_definitions(gnss_test PRIVATE TEST_DIR="${CMAKE_CURRENT_LIST_DIR}/test/")
  target_link_libraries(gnss_test ${PROJECT_NAME} ${catkin_LIBRARIES} yaml-cpp)

  include(GoogleTest)
  gtest_discover_tests(gnss_test)
endif()



###### OLD CONFIG ########
## GENERAL ==============================================================================================================
#cmake_minimum_required(VERSION 3.5)
#project(fixposition_driver LANGUAGES CXX)
#set(CMAKE_CXX_STANDARD 14)
#set(CMAKE_BUILD_TYPE "Release")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=always -Wall -Wextra -Wpedantic -Wno-unused-parameter")
#set(CMAKE_CXX_FLAGS_RELEASE "-O3")
#set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
#
## DEPENDENCIES =========================================================================================================
#find_package(Boost 1.65.0 REQUIRED)
#find_package(Eigen3 REQUIRED)
#find_package(catkin REQUIRED COMPONENTS
#  roscpp
#  tf
#  nav_msgs
#  sensor_msgs
#  std_msgs
#  geometry_msgs
#  message_generation
#  fixposition_gnss_tf
#)
#
#add_message_files(
#    FILES
#    VRTK.msg
#    Speed.msg
#)
#
#generate_messages(
#    DEPENDENCIES
#    std_msgs
#    nav_msgs
#    geometry_msgs
#)
#
#catkin_package(
# INCLUDE_DIRS include
# CATKIN_DEPENDS 
#  tf
#  roscpp geometry_msgs
#  nav_msgs std_msgs message_runtime
#)
#
#include_directories(include ${catkin_INCLUDE_DIRS}  ${EIGEN3_INCLUDE_DIR} ${Boost_INCLUDE_DIR})
#
#
## BUILD EXECUTABLE =====================================================================================================
#add_executable(
#	${PROJECT_NAME}
#  src/fixposition_driver_node.cpp
#  src/fixposition_driver.cpp
#  src/base_converter.cpp
#  src/odometry.cpp
#  src/llh.cpp
#  src/imu.cpp
#  src/tf.cpp
#  src/helper.cpp
#  src/params.cpp
#  
#)
#
#target_link_libraries(${PROJECT_NAME} ${catkin_LIBRARIES} ${Boost_LIBRARIES} pthread)
#add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_generate_messages_cpp)
#
## INSTALL ==============================================================================================================
#install(DIRECTORY include/
#  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
#)
#
#install(TARGETS ${PROJECT_NAME}
#   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )
#
#install(DIRECTORY
#  "launch"
#  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
#)
#
