/*
 *  DGRangeCommandConstants.h
 *  DataGraph
 *
 *  Created by David Adalsteinsson on 7/8/09.
 *  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
 *
 */

typedef enum _DGRangeCommandIntervalType {
    DGRangeCommandEverything = 1,
    DGRangeCommandInterval = 2,
    DGRangeCommandAlternates = 3,
    DGRangeCommandDates = 5,
    DGRangeCommandColumns = 4
} DGRangeCommandIntervalType;

typedef enum _DGRangeCommandDatesType {
    DGRangeCommandCenturies = 8,
    DGRangeCommandDecades = 7,
    DGRangeCommandYears = 1,
    DGRangeCommandMonths = 2,
    DGRangeCommandSunSat = 3,
    DGRangeCommandMonSun = 4,
    DGRangeCommandDays = 5,
    DGRangeCommandHours = 6
} DGRangeCommandDatesType;

typedef enum _DGRangeCommandDatesOddEven {
    DGRangeCommandOdd = 1,
    DGRangeCommandEven = 2
} DGRangeCommandDatesOddEven;

