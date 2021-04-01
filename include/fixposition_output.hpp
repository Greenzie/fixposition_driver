/**
 * @file fixposition_output.hpp
 * @author Andreea Lutac (andreea.lutac@fixposition.ch)
 * @brief
 * version 0.1
 * @date 2020-11-09
 *
 * @copyright Copyright (c) 2020
 *
 */

#ifndef FIXPOSITION_OUTPUT
#define FIXPOSITION_OUTPUT

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <fixposition_output/VRTK.h>
#include <nav_msgs/Odometry.h>
#include <net/if.h>  //ifreq
#include <netdb.h>
#include <netinet/in.h>
#include <ros/console.h>
#include <ros/ros.h>
#include <sensor_msgs/Imu.h>
#include <sensor_msgs/NavSatFix.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <termios.h>
#include <unistd.h>

#include "base_converter.hpp"
#include "fp_msg_converter.hpp"

enum INPUT_TYPE { tcp = 1, serial = 2 };

class FixpositionOutput {
   public:
    FixpositionOutput(ros::NodeHandle* nh);
    ~FixpositionOutput();
    bool InitializeInputConverter();
    bool ReadAndPublish();
    bool CreateTCPSocket();
    bool CreateSerialConnection();
    void Run();
    static void ROSFatalError(const std::string& error);

   private:
    ros::NodeHandle nh_;
    int rate_;
    INPUT_TYPE input_type_;
    std::string input_format_;
    std::string tcp_ip_;
    std::string input_port_;
    int serial_baudrate_;
    int client_fd_ = -1;  //!< TCP or Serial file descriptor
    struct termios options_save_;
    char inbuf_[FP_MSG_MAXLEN];
    size_t inbuf_used_ = 0;

    ros::Publisher odometry_pub_, imu_pub_, navsat_pub_, status_pub_;

    std::unique_ptr<BaseConverter> converter_;
};

#endif