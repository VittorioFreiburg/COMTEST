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

#include "ForceSeatMI_Telemetry.h"

class IForceSeatMI_TelemetryObject
{
public:
	virtual ~IForceSeatMI_TelemetryObject() {}
	virtual void Begin() = 0;
	virtual void End() = 0;
	virtual void Update(float deltaTime) = 0;
	virtual void Pause(bool paused) = 0;
	virtual const FSMI_Telemetry& GetTelemetry() const = 0;
};

