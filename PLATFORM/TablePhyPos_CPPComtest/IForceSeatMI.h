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

#pragma once

#include "ModuleManager.h"
#include "IForceSeatMI_API.h"
#include "IForceSeatMI_VehicleTelemetry.h"
#include "IForceSeatMI_PlaneTelemetry.h"
#include "IForceSeatMI_TelemetryObject.h"

class AWheeledVehicle;

class IForceSeatMI : public IModuleInterface
{
public:
	// !!! DEPRECATED !!!
	// Get reference to API object. The lifespan of the object is managed by this module.
	virtual IForceSeatMI_API& GetAPI() = 0;

	// !!! DEPRECATED !!!
	// Get reference to VehicleTelemetry object. The lifespan of the object is managed by this module.
	virtual IForceSeatMI_VehicleTelemetry& GetVehicleTelemetry() = 0;

	// !!! DEPRECATED !!!
	// Get reference to PlaneTelemetry object. The lifespan of the object is managed by this module.
	virtual IForceSeatMI_PlaneTelemetry& GetPlaneTelemetry() = 0;

	// Activate specified profile in ForceSeatPM application
	virtual bool ActivateProfile(const char* profileName) = 0;

	// Set specific application ID
	virtual bool SetAppID(const char* appId) = 0;

	// Set object that will calculate telemetry and will provide it for the API
	virtual void SetTelemetryObject(IForceSeatMI_TelemetryObject* object) = 0;

	// Call at first to initiate motion control
	virtual void Begin() = 0;

	// Call at the end for proper deinitialization of resources
	virtual void End() = 0;

	// Call this method every frame to update telemtry
	virtual void Update(float deltaTime) = 0;

	virtual void Pause(bool paused) = 0;

	virtual IForceSeatMI_TelemetryObject* CreateVehicle(const AWheeledVehicle& vehicle) = 0;
	virtual IForceSeatMI_TelemetryObject* CreateAeroplane(const APawn& aeroplane) = 0;

	static inline IForceSeatMI& Get()
	{
		return FModuleManager::LoadModuleChecked<IForceSeatMI>("ForceSeatMI");
	}

	static inline bool IsAvailable()
	{
		return FModuleManager::Get().IsModuleLoaded("ForceSeatMI");
	}
};
