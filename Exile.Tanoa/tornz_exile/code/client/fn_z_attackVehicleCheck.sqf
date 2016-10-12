/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private ["_zombie","_return","_pos","_object"];
_zombie = _this;
_return = false;

if (!((vehicle player) isEqualTo player)) then {
  _result = lineIntersectsSurfaces [(getPosASL player),(eyePos _zombie), _zombie];
  if ((count _result) > 0) then {
    if ((count (_result select 0)) > 0) then {
      _pos = ((_result select 0) select 0);
      _object = ((_result select 0) select 2);
      if (_object isEqualTo (vehicle player)) then {
        if (((getPosASL _zombie) distance _pos) < 3.5) then {
          _return = true;
        };
      };
    };
  };
};
_return
