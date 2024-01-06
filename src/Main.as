// c 2024-01-01
// m 2024-01-06

CTrackMania@ App;
float        authorTime = 0.0f;
// bool         gotMap     = false;
float        mapGold    = 0.0f;
float        mapSilver  = 0.0f;
float        mapBronze  = 0.0f;

string title = "\\$FD4" + Icons::Trophy + "\\$G Default Medals";

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void Main() {
    @App = cast<CTrackMania@>(GetApp());
}

void Render() {
    if (!S_Enabled || App is null)
        return;

    UI::SetNextWindowSize(212, 180);

    UI::Begin(title, S_Enabled, UI::WindowFlags::NoResize);
        UI::SetNextItemWidth(142.0f);
        authorTime = UI::InputFloat("##input", authorTime);

        UI::BeginDisabled(authorTime == 0.0f);
            UI::SameLine();
            if (UI::Button("Clear")) {
                authorTime = 0.0f;
                mapGold    = 0.0f;
                mapSilver  = 0.0f;
                mapBronze  = 0.0f;
            }
        UI::EndDisabled();

        UI::BeginDisabled(App.RootMap is null);
        if (UI::Button("Get medals from current map")) {
            authorTime = float(App.RootMap.TMObjective_AuthorTime) / 1000.0f;
            mapGold    = float(App.RootMap.TMObjective_GoldTime)   / 1000.0f;
            mapSilver  = float(App.RootMap.TMObjective_SilverTime) / 1000.0f;
            mapBronze  = float(App.RootMap.TMObjective_BronzeTime) / 1000.0f;
        }
        UI::EndDisabled();

        vec4 medals = GetMedals(authorTime);

        if (UI::BeginTable("##table", 3)) {
            UI::TableSetupColumn("medal", UI::TableColumnFlags::WidthFixed, 69.0f);
            UI::TableSetupColumn("value");
            UI::TableSetupColumn("delta", UI::TableColumnFlags::WidthFixed, 100.0f);

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$2B0Author");
            UI::TableNextColumn(); UI::Text(Time::Format(uint(medals.x)));
            UI::TableNextColumn(); UI::Text("author");

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$FE0Gold");
            UI::TableNextColumn(); UI::Text(Time::Format(uint(medals.y)));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$BBBSilver");
            UI::TableNextColumn(); UI::Text(Time::Format(uint(medals.z)));

            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$A70Bronze");
            UI::TableNextColumn(); UI::Text(Time::Format(uint(medals.w)));

            UI::EndTable();
        }
    UI::End();
}

vec4 GetMedals(float author) {
    float authorMs = author * 1000.0f;

    return vec4(
        authorMs,
        Math::Floor((1000.0f + authorMs + authorMs * 0.06f) / 1000.0f) * 1000.0f,
        Math::Floor((1000.0f + authorMs + authorMs * 0.2f)  / 1000.0f) * 1000.0f,
        Math::Floor((1000.0f + authorMs + authorMs * 0.5f)  / 1000.0f) * 1000.0f
    );
}