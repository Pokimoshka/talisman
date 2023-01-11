<h1>[RE] Talisman</h1>
<hr>
Переписанный плагин <a href="https://c-s.net.ua/forum/topic74308.html">Crux Ansata</a> под ReAPI со своим API
<hr>
<h2>Настройки</h2>
<hr>
// Darken the screen when regenerating health<br>
talisman_screenfede "1"<br>
<br>
// screen darkening color (red shade)<br>
talisman_screenfede_color_r "0"<br>
<br>
// screen darkening color (green shade)<br>
talisman_screenfede_color_g "255"<br>
<br>
// screen darkening color (blue shade)<br>
talisman_screenfede_color_b "0"<br>
<br>
// Highlight a player if he has a talisman<br>
talisman_player_glow "1"<br>
<br>
// Color Glow CT (red shade)<br>
talisman_player_ct_glow_color_r "0"<br>
<br>
// Color Glow CT (green shade)<br>
talisman_player_ct_glow_color_g "255"<br>
<br>
// Color Glow CT (blue shade)<br>
talisman_player_ct_glow_color_b "0"<br>
<br>
// Color Glow TT (red shade)<br>
talisman_player_tt_glow_color_r "0"<br>
<br>
// Color Glow TT (green shade)<br>
talisman_player_tt_glow_color_g "255"<br>
<br>
// Color Glow TT (blue shade)<br>
talisman_player_tt_glow_color_b "0"<br>
<br>
// Minimum number of players to include<br>
talisman_min_player "2"<br>
<br>
// How much will restore health<br>
talisman_give_health "5.0"<br>
<br>
// After how many seconds will health be added<br>
talisman_reg_interval "3.0"<br>
<br>
// Maximum amount of health during regeneration<br>
talisman_max_reg_hp "100.0"<br>
<br>
<h2> API плагина</h2>
<hr>
// The function is called before the talisman is raised<br>
// @param iPlayer  Player index<br>
forward rise_talisman_pre(iPlayer);<br>
<br>
// The function is called after lifting the talisman<br>
// @param iPlayer  Player index<br>
forward rise_talisman_post(iPlayer);<br>
<br>
// The function is called before the talisman is lost<br>
forward drop_talisman_pre();<br>
<br>
// The function is called after the loss of the talisman<br>
// @param iEnt     Entity index<br>
forward drop_talisman_post(iEnt);
<hr>
<h2>Благодарность</h2>
<hr>
<ul>
<li>Mayron - За модель талисмана</li>
<li>Code_0xABC - За отдельные моменты по коду</li>
<li>artfreeman - За ошибки в работе плагина</li>
</ul>
