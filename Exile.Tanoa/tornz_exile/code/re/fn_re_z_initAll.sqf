/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

// Note: This doesn't use Exile Network Framework

{
  if (!(_x isKindOf "TornZ_Base")) exitWith {}; // Security Check
  if (alive _x) then
  {
    _x switchMove "AmovPercMstpSnonWnonDnon_SaluteOut";
  };
} forEach _this;
