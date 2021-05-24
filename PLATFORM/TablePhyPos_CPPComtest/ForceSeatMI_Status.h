/*
 * Copyright (C) 2012-2019 Motion Systems
 * 
 * This file is part of ForceSeat motion system.
 *
 * www.motionsystems.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#ifndef FORCE_SEAT_MI_STATUS_H
#define FORCE_SEAT_MI_STATUS_H

#include "ForceSeatMI_Common.h"

/*
 * List of possible module status values
 */
typedef enum FSMI_ModuleStatus
{
	FSMI_ModuleStatus_Ok                    = 0,
	FSMI_ModuleStatus_Overheated            = 1,
	FSMI_ModuleStatus_Communication_Error   = 2,
	FSMI_ModuleStatus_Config_Error          = 3,
	FSMI_ModuleStatus_RefPointSwitch_Error  = 4,
	FSMI_ModuleStatus_Calibration_Error     = 5,
	FSMI_ModuleStatus_General_Error         = 6,
	FSMI_ModuleStatus_NotConnected_Error    = 7,
	FSMI_ModuleStatus_NoPowerSupply_Error   = 8,
	FSMI_ModuleStatus_FanSpeedTooLow_Error  = 9,
	FSMI_ModuleStatus_OutOfRange_Error      = 10,
	FSMI_ModuleStatus_StallDetected_Error   = 11,
	FSMI_ModuleStatus_EMCY_Error            = 12
} FSMI_ModuleStatus;

/*
 * List of possible motion platform working states
 */
typedef enum FSMI_PlatformCurrentState
{
	FSMI_PlatformCurrentState_AnyPaused            = 1 << 0, // 0b00000001
	FSMI_PlatformCurrentState_ParkingCompleted     = 1 << 1, // 0b00000010
	FSMI_PlatformCurrentState_Offline              = 1 << 2, // 0b00000100

	// Only one park mode is valid at given time.
	// Greater parking mode value (number) = greater priority.
	// It means that transport parking wins over normal parking
	// and normal parking wins over parking to center.
	FSMI_PlatformCurrentState_ParkModeMask         = 0xE0,   // 0b11100000
	FSMI_PlatformCurrentState_NoParking            = 0x00,   // 0b00000000
	FSMI_PlatformCurrentState_SoftParkToCenter     = 0x20,   // 0b00100000
	FSMI_PlatformCurrentState_SoftParkNormal       = 0x40,   // 0b01000000
	FSMI_PlatformCurrentState_SoftParkForTransport = 0x60,   // 0b01100000
	FSMI_PlatformCurrentState_HardParkToCenter     = 0x80,   // 0b10000000
	FSMI_PlatformCurrentState_HardParkNormal       = 0xA0,   // 0b10100000
	FSMI_PlatformCurrentState_HardParkForTransport = 0xC0,   // 0b11000000
	FSMI_PlatformCurrentState_Reserved             = 0xE0,   // 0b11100000

} FSMI_PlatformCurrentState;

/*
 * Actual platform status and motors position
 */
#pragma pack(push, 1)
typedef struct FSMI_PlatformInfo
{
	FSMI_UINT8  structSize; // check if this equals to sizeof(FSMI_PlatformInfo)
	FSMI_UINT64 timemark;
	FSMI_Bool   isConnected;
	FSMI_UINT8  state;      // bits from FSMI_PlatformCurrentState

	FSMI_UINT16 actualMotorPosition[FSMI_MotorsCount];
	FSMI_INT32  actualMotorSpeed[FSMI_MotorsCount];

	FSMI_Bool   isThermalProtectionActivated; // global thermal protection status
	FSMI_UINT8  worstModuleStatus;            // worst module (actuator or CAN node) status - one of FSMI_ModuleStatus
	FSMI_UINT8  worstModuleStatusIndex;       // index of module that above status applies to
	FSMI_Bool   coolingSystemMalfunction;     // global cooling system status

	FSMI_Bool   isKinematicsSupported; // true if Inverse and Forward Kinematics are supported

	FSMI_FLOAT  ikPrecision[FSMI_MotorsCount]; // precision of table precise positioning
	FSMI_Bool   ikRecentStatus;                // true if Inverse Kinematics was calculated correctly and given position is withing operating range

	float       fkRoll;    // roll  in rad from Forward Kinematics
	float       fkPitch;   // pitch in rad from Forward Kinematics
	float       fkYaw;     // yaw   in rad from Forward Kinematics
	float       fkHeave;   // heave in mm  from Forward Kinematics
	float       fkSway;    // sway  in mm  from Forward Kinematics
	float       fkSurge;   // surge in mm  from Forward Kinematics
	FSMI_Bool   fkRecentStatus; // true if Forward Kinematics was calculated correctly

	// New fields in 2.60
	FSMI_UINT16 requiredMotorPosition[FSMI_MotorsCount];

	float       fkRoll_deg;    // roll  in deg from Forward Kinematics
	float       fkPitch_deg;   // pitch in deg from Forward Kinematics
	float       fkYaw_deg;     // yaw   in deg from Forward Kinematics

	float       fkRollSpeed_deg;  // roll  in deg/s from Forward Kinematics
	float       fkPitchSpeed_deg; // pitch in deg/s from Forward Kinematics
	float       fkYawSpeed_deg;   // yaw   in deg/s from Forward Kinematics
	float       fkHeaveSpeed;     // heave in mm/s  from Forward Kinematics
	float       fkSwaySpeed;      // sway  in mm/s  from Forward Kinematics
	float       fkSurgeSpeed;     // surge in mm/s  from Forward Kinematics

	float       fkRollAcc_deg;  // roll  in deg/s2 from Forward Kinematics
	float       fkPitchAcc_deg; // pitch in deg/s2 from Forward Kinematics
	float       fkYawAcc_deg;   // yaw   in deg/s2 from Forward Kinematics
	float       fkHeaveAcc;     // heave in mm/s2  from Forward Kinematics
	float       fkSwayAcc;      // sway  in mm/s2  from Forward Kinematics
	float       fkSurgeAcc;     // surge in mm/s2  from Forward Kinematics

} FSMI_PlatformInfo;
#pragma pack(pop)

#endif
