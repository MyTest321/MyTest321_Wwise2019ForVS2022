/*******************************************************************************
The content of this file includes portions of the AUDIOKINETIC Wwise Technology
released in source code form as part of the SDK installer package.

Commercial License Usage

Licensees holding valid commercial licenses to the AUDIOKINETIC Wwise Technology
may use this file in accordance with the end user license agreement provided
with the software or, alternatively, in accordance with the terms contained in a
written agreement between you and Audiokinetic Inc.

Apache License Usage

Alternatively, this file may be used under the Apache License, Version 2.0 (the
"Apache License"); you may not use this file except in compliance with the
Apache License. You may obtain a copy of the Apache License at
http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed
under the Apache License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
OR CONDITIONS OF ANY KIND, either express or implied. See the Apache License for
the specific language governing permissions and limitations under the License.

  Copyright (c) 2024 Audiokinetic Inc.
*******************************************************************************/

#ifndef ${name}Sink_H
#define ${name}Sink_H

#include "${name}SinkParams.h"

/// See https://www.audiokinetic.com/library/edge/?source=SDK&id=soundengine__plugins__audiodevices.html
/// for the documentation about sink plug-ins
class ${name}Sink
    : public AK::IAkSinkPlugin
{
public:
    ${name}Sink();
    ~${name}Sink();

    /// Plug-in initialization.
    /// Prepares the plug-in for data processing, allocates memory and sets up the initial conditions.
    AKRESULT Init(AK::IAkPluginMemAlloc* in_pAllocator, AK::IAkSinkPluginContext* in_pContext, AK::IAkPluginParam* in_pParams, AkAudioFormat& io_rFormat) override;

    /// Release the resources upon termination of the plug-in.
    AKRESULT Term(AK::IAkPluginMemAlloc* in_pAllocator) override;

    /// The reset action should perform any actions required to reinitialize the
    /// state of the plug-in to its original state (e.g. after Init() or on effect bypass).
    AKRESULT Reset() override;

    /// Plug-in information query mechanism used when the sound engine requires
    /// information about the plug-in to determine its behavior.
    AKRESULT GetPluginInfo(AkPluginInfo& out_rPluginInfo) override;

    /// Obtain the number of audio frames that should be processed by the sound
    /// engine and presented to this plugin via AK::IAkSinkPlugin::Consume().
    /// The size of a frame is determined by the sound engine and obtainable via AK::IAkPluginContextBase::GetMaxBufferLength().
    AKRESULT IsDataNeeded(AkUInt32& out_uNumFramesNeeded) override;

    /// Present an audio buffer to the sink. The audio buffer is in the native format of the sound engine
    /// (typically float, deinterleaved), as specified by io_rFormat passed to Init().
    /// It is up to the plugin to transform it into a format that is compatible with its output.
    void Consume(AkAudioBuffer* in_pInputBuffer, AkRamp in_gain) override;

    /// Called at the end of the audio frame. If no Consume calls were made prior to OnFrameEnd,
    /// this means no audio was sent to the device. Assume silence.
    void OnFrameEnd() override;

    /// Ask the plug-in whether starvation occurred.
    bool IsStarved() override;

    /// Reset the "starvation" flag after IsStarved() returned true.
    void ResetStarved() override;

private:
    ${name}SinkParams* m_pParams;
    AK::IAkPluginMemAlloc* m_pAllocator;
    AK::IAkSinkPluginContext* m_pContext;
    bool m_bStarved;
    bool m_bDataReady;
};

#endif // ${name}Sink_H
