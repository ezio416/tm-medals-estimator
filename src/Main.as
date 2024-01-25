// c 2024-01-01
// m 2024-01-25

float  authorInput = 0.0f;
uint   authorTime  = 0;
uint   calcBronze  = 0;
uint   calcGold    = 0;
uint   calcSilver  = 0;
uint   mapBronze   = 0;
uint   mapGold     = 0;
uint   mapSilver   = 0;
string title       = "\\$FD4" + Icons::Trophy + "\\$G Default Medals";

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Show))
        S_Show = !S_Show;
}

void Main() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    bool inEditor;
    bool wasInEditor = InEditor(App);
    bool inMap;
    bool wasInMap = InMap(App);

    while (true) {
        if (S_Auto) {
            inEditor = InEditor(App);
            inMap = InMap(App);

            if ((S_Editor && inEditor && !wasInEditor) || (inMap && !wasInMap))
                SetMapMedals();

            wasInEditor = inEditor;
            wasInMap = inMap;
        } else {
            wasInEditor = false;
            wasInMap = false;
        }

        yield();
    }
}

void Render() {
    if (!S_Show)
        return;

    UI::Begin(title, S_Show, UI::WindowFlags::AlwaysAutoResize);
        UI::SetNextItemWidth(142.0f);
        authorInput = UI::InputFloat("##input", authorInput);

        UI::BeginDisabled(authorInput == 0.0f);
            UI::SameLine();
            if (UI::Button("Clear")) {
                authorInput = 0;
                authorTime  = 0;
                calcBronze  = 0;
                calcGold    = 0;
                calcSilver  = 0;
                mapBronze   = 0;
                mapGold     = 0;
                mapSilver   = 0;
            }
        UI::EndDisabled();

        UI::BeginDisabled(GetApp().RootMap is null);
        if (UI::Button("Get medals from current map"))
            SetMapMedals();
        UI::EndDisabled();

        uint[] calcMedals = CalcMedals(uint(authorInput * 1000.0f));

        authorTime = calcMedals[0];
        calcGold   = calcMedals[1];
        calcSilver = calcMedals[2];
        calcBronze = calcMedals[3];

        if (UI::BeginTable("##table", 3)) {
            UI::TableSetupColumn("Medal", UI::TableColumnFlags::WidthFixed, 69.0f);
            UI::TableSetupColumn("Default");
            UI::TableSetupColumn("Map Diff");
            UI::TableHeadersRow();

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$2B0Author");
            UI::TableNextColumn(); UI::Text(Time::Format(authorTime));
            UI::TableNextColumn(); UI::Text("+0:00.000");

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$FE0Gold");
            UI::TableNextColumn(); UI::Text(Time::Format(calcGold));
            UI::TableNextColumn(); UI::Text(TimeFormatColoredDiff(calcGold, mapGold));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$BBBSilver");
            UI::TableNextColumn(); UI::Text(Time::Format(calcSilver));
            UI::TableNextColumn(); UI::Text(TimeFormatColoredDiff(calcSilver, mapSilver));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$A70Bronze");
            UI::TableNextColumn(); UI::Text(Time::Format(calcBronze));
            UI::TableNextColumn(); UI::Text(TimeFormatColoredDiff(calcBronze, mapBronze));

            UI::EndTable();
        }
    UI::End();
}

uint[] CalcMedals(uint author) {
    return {
        author,
        uint(Math::Floor((author * 1.06f + 1000.0f) / 1000.0f) * 1000.0f),
        uint(Math::Floor((author * 1.2f  + 1000.0f) / 1000.0f) * 1000.0f),
        uint(Math::Floor((author * 1.5f  + 1000.0f) / 1000.0f) * 1000.0f)
    };
}

uint[] GetMapMedals() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    if (App.RootMap is null || App.RootMap.TMObjective_AuthorTime == uint(-1))
        return { 0, 0, 0, 0 };

    return {
        App.RootMap.TMObjective_AuthorTime,
        App.RootMap.TMObjective_GoldTime,
        App.RootMap.TMObjective_SilverTime,
        App.RootMap.TMObjective_BronzeTime
    };
}

bool InEditor(CTrackMania@ App) {
    return App.Editor !is null && App.RootMap !is null;
}

bool InMap(CTrackMania@ App) {
    return App.Editor is null
        && App.RootMap !is null
        && App.CurrentPlayground !is null
        && App.Network !is null
        && App.Network.ClientManiaAppPlayground !is null;
}

void SetMapMedals() {
    uint[] medals = GetMapMedals();

    if (medals[0] == 0)
        return;

    authorTime = medals[0];
    mapGold    = medals[1];
    mapSilver  = medals[2];
    mapBronze  = medals[3];

    if (S_NotifyCondition != NotifyCondition::None) {
        uint[] calcMedals = CalcMedals(authorTime);

        calcGold   = calcMedals[1];
        calcSilver = calcMedals[2];
        calcBronze = calcMedals[3];

        switch (S_NotifyCondition) {
            case NotifyCondition::AnyChanged:
                if (calcGold != mapGold || calcSilver != mapSilver || calcBronze != mapBronze)
                    UI::ShowNotification(title, "One or more medals are custom!", S_NotifyColor);
                break;
            case NotifyCondition::AnyEasier:
                if (calcGold < mapGold || calcSilver < mapSilver || calcBronze < mapBronze)
                    UI::ShowNotification(title, "One or more medals are easier!", S_NotifyColor);
                break;
            case NotifyCondition::AnyHarder:
                if (calcGold > mapGold || calcSilver > mapSilver || calcBronze > mapBronze)
                    UI::ShowNotification(title, "One or more medals are harder!", S_NotifyColor);
                break;
            case NotifyCondition::GoldChanged:
                if (calcGold != mapGold)
                    UI::ShowNotification(title, "The gold medal is custom!", S_NotifyColor);
                break;
            case NotifyCondition::GoldEasier:
                if (calcGold < mapGold)
                    UI::ShowNotification(title, "The gold medal is easier!", S_NotifyColor);
                break;
            case NotifyCondition::GoldHarder:
                if (calcGold > mapGold)
                    UI::ShowNotification(title, "The gold medal is harder!", S_NotifyColor);
                break;
            case NotifyCondition::SilverChanged:
                if (calcSilver != mapSilver)
                    UI::ShowNotification(title, "The silver medal is custom!", S_NotifyColor);
                break;
            case NotifyCondition::SilverEasier:
                if (calcSilver < mapSilver)
                    UI::ShowNotification(title, "The silver medal is easier!", S_NotifyColor);
                break;
            case NotifyCondition::SilverHarder:
                if (calcSilver > mapSilver)
                    UI::ShowNotification(title, "The silver medal is harder!", S_NotifyColor);
                break;
            case NotifyCondition::BronzeChanged:
                if (calcBronze != mapBronze)
                    UI::ShowNotification(title, "The bronze medal is custom!", S_NotifyColor);
                break;
            case NotifyCondition::BronzeEasier:
                if (calcBronze < mapBronze)
                    UI::ShowNotification(title, "The bronze medal is easier!", S_NotifyColor);
                break;
            case NotifyCondition::BronzeHarder:
                if (calcBronze > mapBronze)
                    UI::ShowNotification(title, "The bronze medal is harder!", S_NotifyColor);
                break;
            default:;
        }
    }

    authorInput = float(authorTime) / 1000.0f;
}

string TimeFormatColoredDiff(uint calc, uint map) {
    if (map == 0)
        return "";

    int diff = int(calc) - int(map);

    return (diff < 0 ? "\\$0F0+" : diff == 0 ? "\\$G+" : "\\$F00\u2212") + Time::Format(Math::Abs(diff));
}