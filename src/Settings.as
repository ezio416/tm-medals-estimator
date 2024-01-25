// c 2024-01-07
// m 2024-01-25

[Setting category="General" name="Show window"]
bool S_Show = false;

[Setting category="General" name="Automatically get medals from current map"]
bool S_Auto = true;

[Setting category="General" name="Automatically get medals when in map editor"]
bool S_Editor = true;

enum NotifyCondition {
    None,
    AnyChanged,
    AnyEasier,
    AnyHarder,
    GoldChanged,
    GoldEasier,
    GoldHarder,
    SilverChanged,
    SilverEasier,
    SilverHarder,
    BronzeChanged,
    BronzeEasier,
    BronzeHarder
}

[Setting category="General" name="Notify when medal times are custom"]
NotifyCondition S_NotifyCondition = NotifyCondition::None;

[Setting category="General" name="Notification color" color]
vec4 S_NotifyColor = vec4(0.8f, 0.4f, 0.1f, 0.8f);