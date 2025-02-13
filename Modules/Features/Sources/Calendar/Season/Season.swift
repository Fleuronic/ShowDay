// Copyright © Fleuronic LLC. All rights reserved.

public import protocol DrumCorpsService.LoadSpec

public struct Season<
	LoadService: LoadSpec
> {
	var days: LoadService.DayLoadResult
	var isLoadingDays: Bool
}
