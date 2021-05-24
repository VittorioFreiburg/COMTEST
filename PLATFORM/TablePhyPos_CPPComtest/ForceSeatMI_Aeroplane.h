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

#include "ForceSeatMI_AbstractTelemetryObject.h"

#include "TransformVectorized.h"
#include "GameFramework/Pawn.h"

class APawn;

class ForceSeatMI_Aeroplane : public ForceSeatMI_AbstractTelemetryObject
{
	explicit ForceSeatMI_Aeroplane(const ForceSeatMI_Aeroplane& other) = delete;
	explicit ForceSeatMI_Aeroplane(const ForceSeatMI_Aeroplane&& other) = delete;

public:
	explicit ForceSeatMI_Aeroplane(const APawn& plane);

public:
	virtual void Begin();
	virtual void End();
	virtual void Update(float deltaTime);
	virtual void Pause(bool paused);

private:
	const APawn& m_plane;
	FTransform   m_prevTransform;
	FVector      m_prevLocation;
	float        m_prevSurgeSpeed;
	float        m_prevSwaySpeed;
	float        m_prevHeaveSpeed;
	bool         m_firstCall;
};
