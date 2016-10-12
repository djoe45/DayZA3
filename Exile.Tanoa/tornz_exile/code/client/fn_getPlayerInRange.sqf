/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

 private["_result","_pos","_distance"];
_result = [];
_pos = _this select 0;
_distance = _this select 1;
{
	if ((_pos distance _x) < _distance) then
	{
		_result pushBack _x;
	};
} forEach allplayers;
_result
