/*
 * Pre-Initialization
 * Author : NiiRoZz
*/
private ['_code', '_function', '_file'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach
[
  ['ZRX_system_ReceiveRequest', 'ZRX_client\code\ZRX_system_ReceiveRequest.sqf']
];
