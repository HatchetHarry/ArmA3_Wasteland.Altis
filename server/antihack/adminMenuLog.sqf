//	@file Name: adminMenuLog.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_name", "_uid", "_action", "_value", "_sentChecksum"];

_sentChecksum = [_this, 4, "", [""]] call BIS_fnc_param;

if (_sentChecksum == _flagChecksum) then
{
	_name = [_this, 0, "", [""]] call BIS_fnc_param;
	_uid = [_this, 1, "", [""]] call BIS_fnc_param;
	_action = [_this, 2, "", [""]] call BIS_fnc_param;
	_value = [_this, 3, "", [0,"",[]]] call BIS_fnc_param;

	_A3W_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;
	switch (_A3W_savingMethod) do
	{
		case 2: {
					["AdminLog" call PDB_objectFileName, "AdminLog", _uid, [_name, _action, _value]] call iniDB_write;
				};
		case 3: {
					_query = "addAdminLog:" + str(call(A3W_extDB_ServerID)) + ":" + str(_uid) + ":" + str(_name) + ":" + str(_action) + ":" + str(_value);
					[_query] call extDB_Database_async;
				};
	};
};
