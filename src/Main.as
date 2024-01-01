// c 2024-01-01
// m 2024-01-01

CTrackMania@ App;
float authorTime = 0.0f;
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

    UI::SetNextWindowSize(240, 180);

    UI::Begin(title, S_Enabled, UI::WindowFlags::NoResize);
        authorTime = UI::InputFloat(" Author", authorTime);

        UI::BeginDisabled(App.RootMap is null);
        if (UI::Button("Get AT from current map")) {
            try {
                authorTime = float(App.RootMap.TMObjective_AuthorTime) / 1000;
            } catch { }
        }
        UI::EndDisabled();

        UI::BeginDisabled(authorTime == 0.0f);
            UI::SameLine();
            if (UI::Button("Clear"))
                authorTime = 0.0f;
        UI::EndDisabled();

        vec4 medals = GetMedals(authorTime);

        if (UI::BeginTable("##table", 2)) {
            UI::TableNextRow();
            UI::TableNextColumn(); UI::Text("\\$2B0Author");
            UI::TableNextColumn(); UI::Text(Time::Format(uint(medals.x)));

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
    float authorMs = author * 1000;

    return vec4(
        authorMs,
        Math::Floor((1000 + authorMs + authorMs * 0.06) / 1000) * 1000,
        Math::Floor((1000 + authorMs + authorMs * 0.2)  / 1000) * 1000,
        Math::Floor((1000 + authorMs + authorMs * 0.5)  / 1000) * 1000
    );
}