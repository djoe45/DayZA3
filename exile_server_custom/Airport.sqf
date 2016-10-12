call {
    if (!isDedicated || worldName != "Altis") exitWith {};
    private ["_fnc","_tr","_side"];
    _fnc = {
        {
            _tr = createTrigger [
                "EmptyDetector",
                _side modelToWorld _x
            ];
            _tr setVariable ["parent", _side];
            _tr setTriggerArea [5, 5, 0, false];
            _tr setTriggerActivation ["ANY", "PRESENT", true];
            _tr setTriggerStatements [
                "this",
                format [
                    "
                        (thisTrigger getVariable 'parent')
                            animate ['Door_%1A_move', 1];
                        (thisTrigger getVariable 'parent') 
                            animate ['Door_%1B_move', 1];
                    ", _forEachIndex + 7
                ],
                format [
                    "
                        (thisTrigger getVariable 'parent') 
                            animate ['Door_%1A_move', 0];
                        (thisTrigger getVariable 'parent') 
                            animate ['Door_%1B_move', 0];
                    ", _forEachIndex + 7
                ]
            ];
            _side setVariable [format [
                "bis_disabled_Door_%1", 
                _forEachIndex + 7
            ], 1, true];
        } forEach _this;
    };
    _side = [14619,16810,0] nearestObject "Land_Airport_left_F";
    [
        [-0.62,-15.16,-7],
        [-0.62,15.16,-7]
    ] call _fnc;
    _side = [14587,16776,0] nearestObject "Land_Airport_right_F";
    [
        [0.62,-15.16,-7],
        [0.62,15.16,-7]
    ] call _fnc;
};