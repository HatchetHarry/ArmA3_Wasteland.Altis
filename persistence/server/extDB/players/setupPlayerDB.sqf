//	@file Name: setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

fn_deletePlayerSave = "persistence\server\extDB\players\deletePlayerSave.sqf" call mf_compile;
fn_loadAccount = "persistence\server\extDB\players\loadAccount.sqf" call mf_compile;


"savePlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_array = _this select 1;

		_player = _array select  0;
		_player_uid = _array select 1;
		_player_lastgroupside = _array select 2;
		_player_lastplayerside = _array select 3;
		_player_bank = _array select 4;

		_data = _array select 5;

		if (!isNull _player && alive _player && _player getVariable ["FAR_isUnconscious", 0] == 0) then
		{

			[format["updatePlayerInfo:%1:%2:%3:%4", _player_uid, _player_lastgroupside, _player_lastPlayerside, _player_bank]] call extDB_async;

			{
				// TODO Redo is Inefficent, overhead + overhead in PV
				[format["updatePlayerSaveValue:%1:%2:%3", _player_uid, (_x select 0), (_x select 1)]] call extDB_async;
			} forEach _data;
		};

		if (!isNull _player && !alive _player) then
		{
			_player_uid call fn_deletePlayerSave;
		};
	};
};

"requestPlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_player = _this select 1;

		applyPlayerData = _player call fn_loadAccount;

		(owner _player) publicVariableClient "applyPlayerData";
	};
};

"deletePlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_player = _this select 1;
		(getPlayerUID _player) call fn_deletePlayerSave;
	};
};