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

platform_registry["Windows_vc170"] = PlatformInfo(
    name="Windows_vc170",
    premake=PremakeInfo(
        actions=("vs2022",)
    ),
    build=BuildInfo(
        command=build,
        configurations=("Debug", "Profile", "Release", "Debug(StaticCRT)", "Profile(StaticCRT)", "Release(StaticCRT)"),
        archs=("Win32", "x64"),
        toolsets=("vc170",),
        on=SUPPORTED_BUILD_SYSTEMS,
        require_configuration=True
    ),
    package=PackageInfo(
        artifacts=[
            os.path.join("SDK", "Win32_vc170", "*", "bin", "{plugin_name}.dll"),
            os.path.join("SDK", "Win32_vc170", "*", "bin", "{plugin_name}.pdb"),
            os.path.join("SDK", "Win32_vc170", "*", "lib", "{plugin_name}*.lib"),
            os.path.join("SDK", "Win32_vc170", "*", "lib", "{plugin_name}*.pdb"),
            os.path.join("SDK", "x64_vc170", "*", "bin", "{plugin_name}.dll"),
            os.path.join("SDK", "x64_vc170", "*", "bin", "{plugin_name}.pdb"),
            os.path.join("SDK", "x64_vc170", "*", "lib", "{plugin_name}*.lib"),
            os.path.join("SDK", "x64_vc170", "*", "lib", "{plugin_name}*.pdb"),
        ]
    )
)
