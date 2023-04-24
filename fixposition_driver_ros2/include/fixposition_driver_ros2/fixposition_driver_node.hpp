/**
 *  @file
 *  @brief Declaration of FixpositionDriver ROS1 Node
 *
 *  ___    ___
 *  \  \  /  /
 *   \  \/  /   Fixposition AG
 *   /  /\  \   All right reserved.
 *  /__/  \__\
 *
 */

#ifndef __FIXPOSITION_DRIVER_ROS2_FIXPOSITION_DRIVER_NODE_
#define __FIXPOSITION_DRIVER_ROS2_FIXPOSITION_DRIVER_NODE_

/* SYSTEM / STL */
#include <termios.h>

#include <unordered_map>

/* ROS2 */
#include <nav_msgs/msg/odometry.h>
#include <rcl/rcl.h>
#include <sensor_msgs/msg/imu.h>
#include <sensor_msgs/msg/nav_sat_fix.h>
#include <tf2_ros/static_transform_broadcaster.h>
#include <tf2_ros/transform_broadcaster.h>
#include <tf2_ros/transform_listener.h>

#include <geometry_msgs/msg/transform_stamped.hpp>

/* FIXPOSITION */
#include <fixposition_driver_lib/fixposition_driver.hpp>

/* PACKAGE */
#include <fixposition_driver_ros2/data_to_ros2.hpp>
#include <fixposition_driver_ros2/msg/speed.hpp>
#include <fixposition_driver_ros2/msg/vrtk.hpp>

namespace fixposition {
class FixpositionDriverNode : public FixpositionDriver {
   public:
    /**
     * @brief Construct a new Fixposition Driver Node object
     *
     * @param[in] params
     */
    FixpositionDriverNode(std::shared_ptr<rclcpp::Node> node, const FixpositionDriverParams& params);

    void Run();

    void RegisterObservers();

    void WsCallback(const fixposition_driver_ros2::msg::Speed::ConstSharedPtr msg);

   private:
    std::shared_ptr<rclcpp::Node> node_;
    rclcpp::Subscription<fixposition_driver_ros2::msg::Speed>::SharedPtr ws_sub_;  //!< wheelspeed message subscriber

    rclcpp::Publisher<sensor_msgs::msg::Imu>::SharedPtr rawimu_pub_;
    rclcpp::Publisher<sensor_msgs::msg::Imu>::SharedPtr corrimu_pub_;
    rclcpp::Publisher<sensor_msgs::msg::NavSatFix>::SharedPtr navsatfix_pub_;
    rclcpp::Publisher<nav_msgs::msg::Odometry>::SharedPtr odometry_pub_;
    rclcpp::Publisher<sensor_msgs::msg::Imu>::SharedPtr poiimu_pub_;             //!< Bias corrected IMU from ODOMETRY
    rclcpp::Publisher<fixposition_driver_ros2::msg::VRTK>::SharedPtr vrtk_pub_;  //!< VRTK message
    rclcpp::Publisher<nav_msgs::msg::Odometry>::SharedPtr odometry_enu0_pub_;    //!< ENU0 Odometry
    rclcpp::Publisher<geometry_msgs::msg::Vector3>::SharedPtr eul_pub_;  //!< Euler angles Yaw-Pitch-Roll in local ENU
    rclcpp::Publisher<geometry_msgs::msg::Vector3>::SharedPtr
        eul_imu_pub_;  //!< Euler angles Pitch-Roll as estimated from the IMU in
                       // local horizontal

    std::shared_ptr<tf2_ros::TransformBroadcaster> br_;
    std::shared_ptr<tf2_ros::StaticTransformBroadcaster> static_br_;
};

}  // namespace fixposition

#endif
