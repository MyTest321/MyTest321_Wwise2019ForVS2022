/*******************************************************************************
The content of this file includes portions of the AUDIOKINETIC Wwise Technology
released in source code form as part of the SDK installer package.

Commercial License Usage

Licensees holding valid commercial licenses to the AUDIOKINETIC Wwise Technology
may use this file in accordance with the end user license agreement provided 
with the software or, alternatively, in accordance with the terms contained in a
written agreement between you and Audiokinetic Inc.

  Version: v2019.2.15  Build: 7667
  Copyright (c) 2006-2022 Audiokinetic Inc.
*******************************************************************************/

//////////////////////////////////////////////////////////////////////
//
// AkPlatformStreamingDefaults.h
//
// Platform-specific default values for streaming and I/O device settings.
//
//////////////////////////////////////////////////////////////////////

#ifndef _AK_PLATFORM_STREAMING_DEFAULTS_H_
#define _AK_PLATFORM_STREAMING_DEFAULTS_H_

// I/O pool settings.

#define AK_DEFAULT_BLOCK_ALLOCATION_TYPE	(0)		// Default memory type.

#define AK_REQUIRED_IO_POOL_ALIGNMENT		(4096)	// If granularity is not a multiple of sector size, I/O data will be buffered by the system; use 4 KB.

#endif //_AK_PLATFORM_STREAMING_DEFAULTS_H_
