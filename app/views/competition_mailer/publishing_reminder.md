Hallo,

deinem Wettkampf *<%= @competition.name %>* am *<%= I18n.l(@competition.date) %>* ist nun schon ein paar Tage her. Du hast die Ergebnisse bisher noch nicht veröffentlicht. Du kannst das gerne noch nachholen und danach den Wettkampf abschließen.

[[Direkt zum Veröffentlichen]](<%= new_competition_publishing_url(@competition.year, @competition.slug) %>)

Trage doch auch gleich den Termin für das nächste Jahr bei Feusport ein. Dann können sich alle gleich das Datum vormerken.
