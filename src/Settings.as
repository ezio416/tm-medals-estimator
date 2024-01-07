// c 2024-01-07
// m 2024-01-07

[Setting category="General" name="Show window"]
bool S_Show = false;

[Setting category="General" name="Automatically get medals from current map" description="Doesn't work in editor"]
bool S_Auto = true;

[Setting category="General" name="Notify when medal times are custom" description="Setting above must be enabled"]
bool S_Notify = false;

[Setting category="General" name="Notification text"]
string S_NotifyText = "One or more medals are custom!";

[Setting category="General" name="Notification color" color]
vec4 S_NotifyColor = vec4(0.8f, 0.4f, 0.1f, 0.8f);