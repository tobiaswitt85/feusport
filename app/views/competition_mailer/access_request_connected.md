Der Nutzer *<%= @user.name %>* hat deine Zugangsanfrage angenommen und sich mit dem Wettkampf [<%= @competition.name %>](<%= competition_show_url(@competition.year, @competition.slug) %>) verbunden.
