/*
 * Author: M3ales
 * Gets VLR/LR/SR radio data from the settings array and returns it
 *
 * Arguments:
 * 0: LR if true, SR if False <BOOLEAN>
 * 1: VLR if True, Above if False <BOOLEAN>
 *
 * Return Value:
 * TFAR Radio Data <ARRAY>
 *
 * Example:
 * [true] call CHTR_TFAR_Setter_fnc_getRadioData
 *
 * Public: No
 */
#include "function_macros.hpp"
#include "defaults.hpp"
params[
	["_lr", true, [true]],
	["_vlr", false, [true]]
];

_settings = call FUNC(loadSettings); // Loads out Settings Dump
if(count _settings == 0) exitWith {
	LOG_ERROR(QUOTE(GVAR(SETTINGS) not initialised));
	[]
};
_profileIndex = (_settings select CURRENTPROFILE_ID) + 1;
_currentProfile = _settings select _profileIndex;

if(!_lr && !_vlr) exitWith {
	LOG("Getting SR Radio Data");
	_currentProfile select SRDATA_INDEX
};

if(_lr || _vlr) exitWith {
	_type = "LR";
	if(_vlr) then {
		_type = "VLR";
	};
	LOGF_1("Loading %1 Radio Data", _type);
	_lrData = _currentProfile select LRDATA_INDEX; // Where LR and VLR info is stored in an array
	_lrIsArrayofArrays = _lrData isEqualTypeArray [[],[]];
	if(!(_lrIsArrayofArrays)) then {
		LOG("Old settings layout detected");
		_lrNewData = call FUNC(copyLegacyLRData);
		_currentProfile set [LRDATA_INDEX, _lrNewData];
		LOG("New Format Applied");
		_lrData = _currentProfile select LRDATA_INDEX; 
	};
	_lrIndex = LR_INDEX; // Where LR data is inside the array
	if(_vlr) then {
		_lrIndex = VLR_INDEX; // Where VLR data is inside the array
	};
	
	_lrDataCount = count _lrData; //TODO: index bounds checking aswell
	if(_lrIndex >= _lrDataCount) exitWith {
		LOG_ERRORF_1("Data Index '%1' is out of range", _lrIndex);
		[]
	};
	if(_lrDataCount > 0) then {
		_lrData select _lrIndex; 
	} else {
		LOG_ERROR("No LR Data for getting. Probably not a good thing"); 
		[]
	};
};

LOG_ERROR("Attempted to load Vehicle Short Range - Unsupported Operation");
[]