"""
The content of this file includes portions of the AUDIOKINETIC Wwise Technology
released in source code form as part of the SDK installer package.

Commercial License Usage

Licensees holding valid commercial licenses to the AUDIOKINETIC Wwise Technology
may use this file in accordance with the end user license agreement provided
with the software or, alternatively, in accordance with the terms contained in a
written agreement between you and Audiokinetic Inc.

  Copyright (c) 2024 Audiokinetic Inc.
"""

from __future__ import absolute_import
import os
from common.command.vs import build, SUPPORTED_BUILD_SYSTEMS
from common.registry import PlatformInfo, PremakeInfo, BuildInfo, PackageInfo, platform_registry

PLATFORM_INFO = PlatformInfo(
    name="Authoring_Windows",
    premake=PremakeInfo(
        actions=("vs2019", "vs2022"),
        platform="windows"
    ),
    build=BuildInfo(
        command=build,
        configurations=("Debug", "Profile", "Release", "Debug_StaticCRT", "Profile_StaticCRT", "Release_StaticCRT"),
        archs=("x64",),
        toolsets=("vc160", "vc170"),
        on=SUPPORTED_BUILD_SYSTEMS,
        require_configuration=True,
        require_toolset=True
    ),
    package=PackageInfo(
        artifacts=[
            os.path.join("Authoring", "x64", "*", "bin", "Plugins", "{plugin_name}", "*"),
            os.path.join("Authoring", "x64", "*", "bin", "Plugins", "{plugin_name}.dll"),
            os.path.join("Authoring", "x64", "*", "bin", "Plugins", "{plugin_name}.xml"),
        ]
    )
)

platform_registry["Authoring_Windows"] = PLATFORM_INFO