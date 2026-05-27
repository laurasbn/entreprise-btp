Set-Location "C:\Users\s_mic\entreprise-btp-site"

$EXISTING = @('climatisation-antibes.html','climatisation-nice.html','climatisation-cannes.html','plombier-nice.html','plombier-cannes.html','serrurier-nice.html','serrurier-grasse.html')

$CITIES = @(
  @{slug="nice";name="Nice";cp="06000";addr="34, av. Georges Cl&eacute;menceau";area="Vieux-Nice, Cimiez, Fabron, Saint-Isidore, l'Ariane et Saint-Augustin";nearby="Cagnes-sur-Mer, Saint-Laurent-du-Var et la m&eacute;tropole ni&ccedil;oise";intro="Nice, chef-lieu des Alpes-Maritimes et capitale de la C&ocirc;te d'Azur, compte plus de 350 000 habitants r&eacute;partis dans des quartiers aux profils tr&egrave;s vari&eacute;s.";shortAddr="34, av. Georges Cl&eacute;menceau, 06000 Nice"},
  @{slug="cannes";name="Cannes";cp="06400";addr="5 Rue Boucicaut";area="Cannes centre, La Croisette, La Bocca, Le Cannet, Mougins et Mandelieu-la-Napoule";nearby="Antibes, Grasse et toute la c&ocirc;te cannoise";intro="Cannes, mondialement connue pour son Festival du Film, est aussi une ville &agrave; fort tissu r&eacute;sidentiel et h&ocirc;telier. La haute saison estivale y rend toute urgence encore plus critique.";shortAddr="5 Rue Boucicaut, 06400 Cannes"},
  @{slug="antibes";name="Antibes";cp="06600";addr="12 avenue de l'Est&eacute;rel";area="Antibes centre, Juan-les-Pins, Sophia-Antipolis, Cap d'Antibes et Vallauris";nearby="Cannes, Nice et la c&ocirc;te d'Azur";intro="Antibes Juan-les-Pins est l'une des plus grandes communes des Alpes-Maritimes, combinant centre historique m&eacute;di&eacute;val, technop&ocirc;le de Sophia-Antipolis et plages de Juan-les-Pins.";shortAddr="12 avenue de l'Est&eacute;rel, 06600 Antibes"},
  @{slug="grasse";name="Grasse";cp="06130";addr="24 avenue Mathias Duval";area="Grasse centre, Saint-Jacques, La Paoute, Plan-de-Grasse, Mougins, Mouans-Sartoux et Valbonne";nearby="Cannes, Antibes et l'arri&egrave;re-pays";intro="Grasse, capitale mondiale du parfum, est une commune des hauteurs avec un tissu r&eacute;sidentiel dense. Son territoire &eacute;tendu et ses nombreux hameaux requi&egrave;rent des prestataires locaux r&eacute;actifs.";shortAddr="24 avenue Mathias Duval, 06130 Grasse"},
  @{slug="le-cannet";name="Le Cannet";cp="06110";addr="5 Rue Boucicaut";area="Le Cannet, Rocheville, cannes La Bocca et Mougins";nearby="Cannes, Grasse et Mougins";intro="Le Cannet est une commune r&eacute;sidentielle surplombant Cannes, r&eacute;put&eacute;e pour ses ruelles du vieux village, ses quartiers pavillonnaires et sa vue panoramique sur la baie de Cannes.";shortAddr="5 Rue Boucicaut, 06400 Cannes (agence)"},
  @{slug="cagnes-sur-mer";name="Cagnes-sur-Mer";cp="06800";addr="34, av. Georges Cl&eacute;menceau";area="Cagnes-sur-Mer, Cros-de-Cagnes, Haut-de-Cagnes et la vall&eacute;e du Var";nearby="Nice, Antibes et la m&eacute;tropole ni&ccedil;oise";intro="Cagnes-sur-Mer, entre Nice et Antibes, allie station baln&eacute;aire, village m&eacute;di&eacute;val perch&eacute; et zone r&eacute;sidentielle. Sa situation en fait un point strat&eacute;gique de la C&ocirc;te d'Azur.";shortAddr="34, av. Georges Cl&eacute;menceau, 06000 Nice (agence)"},
  @{slug="saint-laurent-du-var";name="Saint-Laurent-du-Var";cp="06700";addr="34, av. Georges Cl&eacute;menceau";area="Saint-Laurent-du-Var, Cap 3000, les Plans et Carros";nearby="Nice, Antibes et Cagnes-sur-Mer";intro="Saint-Laurent-du-Var, aux portes de Nice, est une commune dynamique abritant le centre commercial Cap 3000, de nombreuses r&eacute;sidences et une importante zone d'activit&eacute;s &eacute;conomiques.";shortAddr="34, av. Georges Cl&eacute;menceau, 06000 Nice (agence)"}
)

$TRADES = @(
  @{
    prefix="climatisation"; nom="Climatisation"; jsonNom="Climatisation"
    breadcrumb="Climatisation"; pill="&#10052;&#65039; Installateur climatisation"
    h1r="Installation &amp; D&eacute;pannage"; heroSub="Installation de climatiseurs split, multi-split et gainables. Devis gratuit sous 2h, techniciens qualifi&eacute;s disponibles 7j/7."
    h2="Sp&eacute;cialiste climatisation &agrave;"; ctaEmoji="&#10052;&#65039;"; ctaUrgence="Installez votre climatisation &agrave;"
    ctaPara="Devis gratuit sous 2h &mdash; Techniciens qualifi&eacute;s disponibles 7j/7."
    metaSub="Installation Split &amp; D&eacute;pannage"
    metaDescTpl="Climatisation &agrave; %%CITY%% (%%CP%%) : installation split, multi-split, d&eacute;pannage urgent. Atelier PACA &#11088; 4,9/5 &mdash; 166 avis Google. Devis gratuit, intervention rapide &agrave; %%CITY%% et ses environs."
    kwTpl="climatisation %%CITY%%, installateur climatisation %%CITY%%, pose climatiseur %%CITY%%, d&eacute;pannage clim %%CITY%%, installation split %%CITY%%"
    jsonDesc="Installation et d&eacute;pannage climatisation"
    p1Tpl="Avec des &eacute;t&eacute;s de plus en plus chauds sur la C&ocirc;te d'Azur, un climatiseur r&eacute;versible est devenu indispensable &agrave; %%CITY%%. Atelier PACA met &agrave; votre disposition des techniciens qualifi&eacute;s, bas&eacute;s localement, pour l'installation, l'entretien et le d&eacute;pannage de climatisation &agrave; %%CITY%% et dans tout le secteur."
    p2Tpl="Nos techniciens ma&icirc;trisent les contraintes locales de %%CITY%% : r&egrave;glements d'urbanisme, copropri&eacute;t&eacute;s, b&acirc;timents anciens. Nous intervenons aussi bien en appartement, maison individuelle que dans les locaux commerciaux. Devis d&eacute;taill&eacute;, transparent et envoy&eacute; sous 2h sans engagement."
    servH3="Nos prestations climatisation &agrave; %%CITY%%"
    zoneH3="Zone d'intervention : %%CITY%% et ses environs"
    zonePTpl="Nous intervenons dans tout le secteur de %%CITY%% : %%AREA%%. N'attendez pas les fortes chaleurs pour nous contacter : <strong>04 92 14 14 14</strong>."
    services=@(
      "<strong>Pose de climatiseur split mural</strong> &mdash; installation propre et discr&egrave;te, respect des copropri&eacute;t&eacute;s",
      "<strong>Climatisation r&eacute;versible</strong> &mdash; confort chaud en hiver, frais en &eacute;t&eacute;",
      "<strong>Syst&egrave;me multi-split</strong> &mdash; climatisez plusieurs pi&egrave;ces avec une seule unit&eacute; ext&eacute;rieure",
      "<strong>Climatiseur gainable</strong> &mdash; installation invisible, int&eacute;gration parfaite au b&acirc;ti",
      "<strong>Entretien et maintenance</strong> &mdash; contrat d'entretien annuel, nettoyage des filtres",
      "<strong>D&eacute;pannage urgent</strong> &mdash; panne en plein &eacute;t&eacute; ? On intervient le jour m&ecirc;me"
    )
    hl1t="Agence locale"; hl2t="&#11088; 4,9/5 Google"; hl3t="Devis sous 2h"; hl4t="D&eacute;pannage urgent"
    hl2d="166 avis v&eacute;rifi&eacute;s"; hl3d="R&eacute;ponse garantie sous 2 heures"; hl4d="Intervention le jour m&ecirc;me"
    relH3="&#128205; Autres villes et services climatisation"
    relLinks='<a href="climatisation-nice.html">Climatisation Nice</a><a href="climatisation-cannes.html">Climatisation Cannes</a><a href="climatisation-antibes.html">Climatisation Antibes</a><a href="climatisation-grasse.html">Climatisation Grasse</a><a href="plombier-nice.html">Plombier Nice</a>'
  },
  @{
    prefix="plombier"; nom="Plomberie"; jsonNom="Plombier"
    breadcrumb="Plomberie"; pill="&#128295; Plombier"
    h1r="D&eacute;pannage &amp; Urgence"; heroSub="Fuite d'eau, canalisation bouch&eacute;e, chauffe-eau en panne ? Nos plombiers interviennent en urgence 24h/24 et 7j/7."
    h2="Plombier d'urgence &agrave;"; ctaEmoji="&#128680;"; ctaUrgence="Urgence plomberie &agrave;"
    ctaPara="Un plombier disponible maintenant &mdash; intervention 24h/24 et 7j/7."
    metaSub="Fuite Eau &amp; Urgence 24h/24"
    metaDescTpl="Plombier &agrave; %%CITY%% (%%CP%%) : d&eacute;pannage fuite d'eau, canalisation bouch&eacute;e, chauffe-eau, urgence 24h/24. Atelier PACA &#11088; 4,9/5 &mdash; 166 avis Google. Intervention rapide &agrave; %%CITY%% et ses environs."
    kwTpl="plombier %%CITY%%, d&eacute;pannage plomberie %%CITY%%, fuite eau %%CITY%%, plombier urgence %%CITY%%, canalisation bouch&eacute;e %%CITY%%, chauffe-eau %%CITY%%"
    jsonDesc="D&eacute;pannage plomberie"
    p1Tpl="Une fuite d'eau, une canalisation bloqu&eacute;e ou un chauffe-eau en panne peuvent vite devenir une urgence &agrave; %%CITY%%. Atelier PACA met &agrave; votre disposition des plombiers qualifi&eacute;s, disponibles 24 heures sur 24, tous les jours de l'ann&eacute;e pour intervenir dans tout le secteur de %%CITY%%."
    p2Tpl="Nous savons qu'une urgence plomberie ne pr&eacute;vient pas. C'est pourquoi nos &eacute;quipes &agrave; %%CITY%% s'engagent &agrave; vous r&eacute;pondre imm&eacute;diatement et &agrave; intervenir dans les meilleurs d&eacute;lais. Nos tarifs vous sont communiqu&eacute;s avant toute intervention."
    servH3="Nos interventions plomberie &agrave; %%CITY%%"
    zoneH3="Zone d'intervention : %%CITY%% et ses environs"
    zonePTpl="Nous intervenons dans tout le secteur de %%CITY%% : %%AREA%%. En cas d'urgence plomberie, appelez imm&eacute;diatement le <strong>04 92 14 14 14</strong>."
    services=@(
      "<strong>Fuite d'eau</strong> &mdash; d&eacute;tection et r&eacute;paration rapide, limitation des d&eacute;g&acirc;ts des eaux",
      "<strong>Canalisation bouch&eacute;e</strong> &mdash; d&eacute;bouchage par haute pression ou furet m&eacute;canique",
      "<strong>Chauffe-eau &eacute;lectrique et gaz</strong> &mdash; d&eacute;pannage, entretien, remplacement",
      "<strong>Robinetterie et sanitaires</strong> &mdash; remplacement robinets, mitigeurs, WC",
      "<strong>Salle de bain</strong> &mdash; installation douche, baignoire, WC suspendu",
      "<strong>Plomberie de r&eacute;novation</strong> &mdash; remise aux normes, nouveaux r&eacute;seaux"
    )
    hl1t="Urgence 24h/24"; hl2t="&#11088; 4,9/5 Google"; hl3t="Tarif transparent"; hl4t="Intervention rapide"
    hl2d="166 avis v&eacute;rifi&eacute;s"; hl3d="Devis communiqu&eacute; avant intervention"; hl4d="Plombier disponible maintenant"
    relH3="&#128205; Autres services dans les Alpes-Maritimes"
    relLinks='<a href="plombier-nice.html">Plombier Nice</a><a href="plombier-cannes.html">Plombier Cannes</a><a href="plombier-antibes.html">Plombier Antibes</a><a href="climatisation-nice.html">Climatisation Nice</a><a href="serrurier-nice.html">Serrurier Nice</a>'
  },
  @{
    prefix="electricien"; nom="Electricit&eacute;"; jsonNom="Electricien"
    breadcrumb="&Eacute;lectricit&eacute;"; pill="&#9889; &Eacute;lectricien"
    h1r="D&eacute;pannage &amp; Installation"; heroSub="Panne &eacute;lectrique, mise aux normes, tableau &eacute;lectrique, prises ? Nos &eacute;lectriciens interviennent rapidement 24h/24 et 7j/7."
    h2="&Eacute;lectricien qualifi&eacute; &agrave;"; ctaEmoji="&#9889;"; ctaUrgence="Urgence &eacute;lectrique &agrave;"
    ctaPara="Un &eacute;lectricien disponible maintenant &mdash; intervention rapide 24h/24."
    metaSub="Panne &Eacute;lectrique &amp; Mise aux Normes"
    metaDescTpl="Electricien &agrave; %%CITY%% (%%CP%%) : d&eacute;pannage panne &eacute;lectrique, mise aux normes tableau, installation prises. Atelier PACA &#11088; 4,9/5 &mdash; 166 avis Google. Intervention rapide 24h/24 &agrave; %%CITY%%."
    kwTpl="electricien %%CITY%%, d&eacute;pannage &eacute;lectrique %%CITY%%, panne &eacute;lectrique %%CITY%%, tableau &eacute;lectrique %%CITY%%, mise aux normes &eacute;lectrique %%CITY%%"
    jsonDesc="D&eacute;pannage et installation &eacute;lectrique"
    p1Tpl="Panne de courant, disjoncteur qui saute, installation &eacute;lectrique v&eacute;tuste ou non conforme &agrave; %%CITY%% ? Atelier PACA met &agrave; votre disposition des &eacute;lectriciens qualifi&eacute;s, disponibles 24h/24, intervenant dans tous les secteurs de %%CITY%% et ses environs."
    p2Tpl="Nos &eacute;lectriciens &agrave; %%CITY%% traitent aussi bien les urgences nocturnes que les travaux planifi&eacute;s : mise aux normes NF C 15-100, r&eacute;novation compl&egrave;te d'installation, ajout de circuits. Nos devis sont d&eacute;taill&eacute;s et transmis avant toute intervention."
    servH3="Nos prestations &eacute;lectricit&eacute; &agrave; %%CITY%%"
    zoneH3="Zone d'intervention : %%CITY%% et ses environs"
    zonePTpl="Nos &eacute;lectriciens interviennent dans tout le secteur de %%CITY%% : %%AREA%%. Pour toute urgence &eacute;lectrique, appelez le <strong>04 92 14 14 14</strong>."
    services=@(
      "<strong>D&eacute;pannage panne &eacute;lectrique</strong> &mdash; diagnostic et remise en service rapide",
      "<strong>Tableau &eacute;lectrique</strong> &mdash; mise aux normes, remplacement, disjoncteurs diff&eacute;rentiels",
      "<strong>Installation prises et interrupteurs</strong> &mdash; ajout de circuits, d&eacute;placement de prises",
      "<strong>&Eacute;clairage LED</strong> &mdash; remplacement luminaires, spots encastr&eacute;s, &eacute;clairage ext&eacute;rieur",
      "<strong>Domotique</strong> &mdash; volets motoris&eacute;s, &eacute;clairage connect&eacute;, gestion &eacute;nergie",
      "<strong>Mise aux normes NF C 15-100</strong> &mdash; conformit&eacute; obligatoire pour location ou vente"
    )
    hl1t="Urgence 24h/24"; hl2t="&#11088; 4,9/5 Google"; hl3t="Devis avant travaux"; hl4t="NF C 15-100"
    hl2d="166 avis v&eacute;rifi&eacute;s"; hl3d="Tarification transparente"; hl4d="Mise aux normes certifi&eacute;e"
    relH3="&#128205; Autres services dans les Alpes-Maritimes"
    relLinks='<a href="electricien-nice.html">Electricien Nice</a><a href="electricien-cannes.html">Electricien Cannes</a><a href="electricien-antibes.html">Electricien Antibes</a><a href="plombier-nice.html">Plombier Nice</a><a href="climatisation-nice.html">Climatisation Nice</a>'
  },
  @{
    prefix="chauffagiste"; nom="Chauffage"; jsonNom="Chauffagiste"
    breadcrumb="Chauffage"; pill="&#128293; Chauffagiste"
    h1r="Chaudi&egrave;re &amp; Pompe &agrave; Chaleur"; heroSub="Panne de chaudi&egrave;re, entretien annuel, installation pompe &agrave; chaleur ? Nos chauffagistes interviennent rapidement 24h/24 et 7j/7."
    h2="Chauffagiste qualifi&eacute; &agrave;"; ctaEmoji="&#128293;"; ctaUrgence="Urgence chauffage &agrave;"
    ctaPara="Un chauffagiste disponible rapidement &mdash; devis gratuit sous 2h."
    metaSub="Chaudi&egrave;re, PAC &amp; Entretien"
    metaDescTpl="Chauffagiste &agrave; %%CITY%% (%%CP%%) : d&eacute;pannage chaudi&egrave;re, entretien, installation pompe &agrave; chaleur. Atelier PACA &#11088; 4,9/5 &mdash; 166 avis Google. Intervention rapide 24h/24 &agrave; %%CITY%%."
    kwTpl="chauffagiste %%CITY%%, d&eacute;pannage chaudi&egrave;re %%CITY%%, entretien chaudi&egrave;re %%CITY%%, pompe &agrave; chaleur %%CITY%%, plombier chauffagiste %%CITY%%"
    jsonDesc="D&eacute;pannage et installation chauffage"
    p1Tpl="Chaudi&egrave;re en panne, radiateurs froids ou installation de chauffage &agrave; pr&eacute;voir &agrave; %%CITY%% ? Atelier PACA dispose d'une &eacute;quipe de chauffagistes qualifi&eacute;s, bas&eacute;e &agrave; proximit&eacute; de %%CITY%%, pour tous vos besoins en chauffage, disponibles 24h/24."
    p2Tpl="Bien que la C&ocirc;te d'Azur b&eacute;n&eacute;ficie d'un climat doux, un syst&egrave;me de chauffage fiable reste indispensable &agrave; %%CITY%% pour les mois d'hiver. Nos techniciens interviennent sur tous types d'&eacute;quipements : chaudi&egrave;re gaz, fioul, pompe &agrave; chaleur et plancher chauffant."
    servH3="Nos prestations chauffage &agrave; %%CITY%%"
    zoneH3="Zone d'intervention : %%CITY%% et ses environs"
    zonePTpl="Nos chauffagistes interviennent dans tout le secteur de %%CITY%% : %%AREA%%. Pour toute urgence chauffage, appelez le <strong>04 92 14 14 14</strong>."
    services=@(
      "<strong>D&eacute;pannage chaudi&egrave;re gaz et fioul</strong> &mdash; intervention d'urgence pour remettre le chauffage en service",
      "<strong>Entretien annuel chaudi&egrave;re</strong> &mdash; nettoyage, r&eacute;glage, attestation d'entretien obligatoire",
      "<strong>Pompe &agrave; chaleur air/eau</strong> &mdash; installation et mise en service PAC r&eacute;versible",
      "<strong>Plancher chauffant</strong> &mdash; installation et d&eacute;pannage plancher chauffant hydraulique",
      "<strong>Radiateurs et robinets thermostatiques</strong> &mdash; remplacement et &eacute;quilibrage du circuit",
      "<strong>Ballon eau chaude</strong> &mdash; d&eacute;pannage, d&eacute;tartrage et remplacement ballon"
    )
    hl1t="Urgence 24h/24"; hl2t="&#11088; 4,9/5 Google"; hl3t="Entretien annuel"; hl4t="Toutes marques"
    hl2d="166 avis v&eacute;rifi&eacute;s"; hl3d="Attestation officielle fournie"; hl4d="Daikin, Viessmann, De Dietrich..."
    relH3="&#128205; Autres services dans les Alpes-Maritimes"
    relLinks='<a href="chauffagiste-nice.html">Chauffagiste Nice</a><a href="chauffagiste-cannes.html">Chauffagiste Cannes</a><a href="chauffagiste-antibes.html">Chauffagiste Antibes</a><a href="plombier-nice.html">Plombier Nice</a><a href="climatisation-nice.html">Climatisation Nice</a>'
  },
  @{
    prefix="serrurier"; nom="Serrurerie"; jsonNom="Serrurier"
    breadcrumb="Serrurerie"; pill="&#128274; Serrurier"
    h1r="Ouverture Porte &amp; Urgence"; heroSub="Porte claqu&eacute;e, serrure bloqu&eacute;e, effraction ? Nos serruriers interviennent en urgence 24h/24 et 7j/7. Tarifs affich&eacute;s, sans mauvaise surprise."
    h2="Serrurier d'urgence &agrave;"; ctaEmoji="&#128680;"; ctaUrgence="Porte bloqu&eacute;e &agrave;"
    ctaPara="Un serrurier qualifi&eacute; intervient dans les meilleurs d&eacute;lais, 24h/24 et 7j/7."
    metaSub="Ouverture Porte &amp; Urgence 24h/24"
    metaDescTpl="Serrurier &agrave; %%CITY%% (%%CP%%) : ouverture de porte claqu&eacute;e, changement de serrure, blindage. Atelier PACA &#11088; 4,9/5 &mdash; 166 avis Google. Intervention urgente 24h/24 &agrave; %%CITY%%."
    kwTpl="serrurier %%CITY%%, ouverture porte %%CITY%%, serrurier urgence %%CITY%%, changement serrure %%CITY%%, serrurier 24h %%CITY%%"
    jsonDesc="Serrurier d'urgence"
    p1Tpl="Vous &ecirc;tes bloqu&eacute; devant votre porte &agrave; %%CITY%% ? Votre serrure est d&eacute;fectueuse ou votre logement a subi une tentative d'effraction ? Atelier PACA met &agrave; votre disposition des serruriers qualifi&eacute;s, disponibles 24 heures sur 24, tous les jours de l'ann&eacute;e."
    p2Tpl="Chez Atelier PACA, nous n'appliquons pas de tarifs abusifs, m&ecirc;me en urgence nocturne. Avant toute intervention &agrave; %%CITY%%, nos techniciens vous communiquent le co&ucirc;t estim&eacute; et vous laissent libre de d&eacute;cider. En cas d'ouverture de porte, nous privil&eacute;gions toujours les m&eacute;thodes non destructives."
    servH3="Nos prestations serrurerie &agrave; %%CITY%%"
    zoneH3="Zone d'intervention : %%CITY%% et ses environs"
    zonePTpl="Nos serruriers interviennent dans tout le secteur de %%CITY%% : %%AREA%%. Objectif : &ecirc;tre chez vous en 30 minutes. Appelez le <strong>04 92 14 14 14</strong>."
    services=@(
      "<strong>Ouverture de porte claqu&eacute;e</strong> &mdash; sans d&eacute;t&eacute;rioration si possible, m&eacute;thode douce privil&eacute;gi&eacute;e",
      "<strong>Changement de serrure</strong> &mdash; remplacement de cylindre ou serrure compl&egrave;te",
      "<strong>Blindage de porte</strong> &mdash; renforcement s&eacute;curit&eacute; de votre logement",
      "<strong>Apr&egrave;s effraction</strong> &mdash; s&eacute;curisation d'urgence et remplacement rapide",
      "<strong>Serrure multipoints</strong> &mdash; installation serrures 3 ou 5 points",
      "<strong>Digicodes et badges</strong> &mdash; contr&ocirc;le d'acc&egrave;s pour copropri&eacute;t&eacute;s et locaux"
    )
    hl1t="Urgence 24h/24"; hl2t="&#11088; 4,9/5 Google"; hl3t="Tarif transparent"; hl4t="Objectif 30 min"
    hl2d="166 avis v&eacute;rifi&eacute;s"; hl3d="Prix communiqu&eacute; avant intervention"; hl4d="Intervention rapide &agrave; domicile"
    relH3="&#128205; Autres services dans les Alpes-Maritimes"
    relLinks='<a href="serrurier-nice.html">Serrurier Nice</a><a href="serrurier-cannes.html">Serrurier Cannes</a><a href="serrurier-antibes.html">Serrurier Antibes</a><a href="serrurier-grasse.html">Serrurier Grasse</a><a href="plombier-nice.html">Plombier Nice</a>'
  },
  @{
    prefix="volets-roulants"; nom="Volets Roulants"; jsonNom="Volets roulants"
    breadcrumb="Volets roulants"; pill="&#127968; Volets roulants"
    h1r="Installation &amp; D&eacute;pannage"; heroSub="Volet bloqu&eacute;, moteur HS, installation neuve ? Nos techniciens interviennent rapidement pour tous vos volets roulants, 7j/7 dans toute la r&eacute;gion."
    h2="Sp&eacute;cialiste volets roulants &agrave;"; ctaEmoji="&#127968;"; ctaUrgence="Volet bloqu&eacute; &agrave;"
    ctaPara="Devis gratuit sous 2h &mdash; Techniciens qualifi&eacute;s disponibles 7j/7."
    metaSub="Installation &amp; D&eacute;pannage Motorisation"
    metaDescTpl="Volets roulants &agrave; %%CITY%% (%%CP%%) : installation, motorisation, d&eacute;pannage volet bloqu&eacute;. Atelier PACA &#11088; 4,9/5 &mdash; 166 avis Google. Techniciens qualifi&eacute;s &agrave; %%CITY%% et ses environs."
    kwTpl="volets roulants %%CITY%%, motorisation volets %%CITY%%, installation volets roulants %%CITY%%, r&eacute;paration volets %%CITY%%, volet bloqu&eacute; %%CITY%%"
    jsonDesc="Installation et d&eacute;pannage volets roulants"
    p1Tpl="Volet roulant bloqu&eacute;, lames abim&eacute;es ou motorisation &agrave; installer &agrave; %%CITY%% ? Atelier PACA dispose de techniciens sp&eacute;cialis&eacute;s dans les volets roulants, intervenant sur toute la commune de %%CITY%% et ses environs, 7 jours sur 7."
    p2Tpl="Que vous souhaitiez motoriser vos volets existants &agrave; %%CITY%%, installer de nouveaux volets roulants ou r&eacute;parer un moteur Somfy ou Nice d&eacute;faillant, nos techniciens qualifi&eacute;s vous proposent un devis d&eacute;taill&eacute; et transparent envoy&eacute; sous 2h."
    servH3="Nos prestations volets roulants &agrave; %%CITY%%"
    zoneH3="Zone d'intervention : %%CITY%% et ses environs"
    zonePTpl="Nos techniciens volets roulants interviennent dans tout le secteur de %%CITY%% : %%AREA%%. Appelez le <strong>04 92 14 14 14</strong> ou demandez un devis gratuit en ligne."
    services=@(
      "<strong>Motorisation de volets</strong> &mdash; passage en motorisation &eacute;lectrique avec t&eacute;l&eacute;commande",
      "<strong>Installation volets neufs</strong> &mdash; aluminium, PVC ou bois, sur mesure",
      "<strong>R&eacute;paration moteur Somfy / Nice / Came</strong> &mdash; d&eacute;pannage et remplacement moteur",
      "<strong>Remplacement de lames</strong> &mdash; tablier abim&eacute; ou cass&eacute; r&eacute;par&eacute; rapidement",
      "<strong>Stores et bannes</strong> &mdash; installation et motorisation stores banne ext&eacute;rieurs",
      "<strong>Domotique volets</strong> &mdash; int&eacute;gration box domotique, commande smartphone"
    )
    hl1t="Agence locale"; hl2t="&#11088; 4,9/5 Google"; hl3t="Devis sous 2h"; hl4t="Toutes marques"
    hl2d="166 avis v&eacute;rifi&eacute;s"; hl3d="R&eacute;ponse garantie sous 2 heures"; hl4d="Somfy, Nice, Came, Bubendorff..."
    relH3="&#128205; Autres services dans les Alpes-Maritimes"
    relLinks='<a href="volets-roulants-nice.html">Volets Nice</a><a href="volets-roulants-cannes.html">Volets Cannes</a><a href="volets-roulants-antibes.html">Volets Antibes</a><a href="climatisation-nice.html">Climatisation Nice</a><a href="serrurier-nice.html">Serrurier Nice</a>'
  }
)

$CSS = @'
    *,*::before,*::after{margin:0;padding:0;box-sizing:border-box}
    :root{--rouge:#E63946;--bleu:#1D3557;--gris:#F7F8FA;--gris2:#EEF0F3;--texte:#111827;--sous:#6B7280}
    html{scroll-behavior:smooth}body{font-family:'Inter',sans-serif;color:var(--texte);background:#fff;overflow-x:hidden}
    header{position:sticky;top:0;z-index:100;background:var(--bleu);height:66px;display:flex;align-items:center;justify-content:space-between;padding:0 48px;box-shadow:0 4px 20px rgba(0,0,0,0.25)}
    .logo{display:flex;align-items:center;gap:12px;text-decoration:none}.logo-icon{width:40px;height:40px;background:var(--rouge);border-radius:8px;display:flex;align-items:center;justify-content:center;font-weight:900;color:#fff;font-size:15px}.logo-nom{font-size:18px;font-weight:700;color:#fff}.logo-nom span{color:var(--rouge)}
    .header-right{display:flex;align-items:center;gap:16px}.header-tel{color:#fff;font-weight:700;font-size:15px;white-space:nowrap;text-decoration:none}.btn-devis-h{background:var(--rouge);color:#fff;font-weight:700;border-radius:8px;padding:8px 18px;text-decoration:none;font-size:14px}
    .hero{background:linear-gradient(135deg,#0a1628 0%,var(--bleu) 60%,#0a1628 100%);padding:80px 48px;text-align:center}
    .breadcrumb{font-size:13px;color:rgba(255,255,255,0.5);margin-bottom:20px}.breadcrumb a{color:rgba(255,255,255,0.6);text-decoration:none}
    .hero-pill{display:inline-flex;align-items:center;gap:8px;background:rgba(230,57,70,0.20);border:1px solid rgba(230,57,70,0.50);color:#f87171;font-size:13px;font-weight:600;padding:5px 16px;border-radius:100px;margin-bottom:24px}
    .hero h1{color:#fff;font-size:clamp(28px,4.5vw,52px);font-weight:900;line-height:1.1;letter-spacing:-1px;margin-bottom:18px}.hero h1 em{color:#60c5f7;font-style:normal}
    .hero-sub{color:rgba(255,255,255,0.75);font-size:clamp(15px,1.6vw,17px);max-width:560px;margin:0 auto 32px;line-height:1.7}
    .hero-btns{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}
    .btn-rouge{background:var(--rouge);color:#fff;padding:14px 28px;border-radius:10px;text-decoration:none;font-weight:700;font-size:16px;box-shadow:0 4px 18px rgba(230,57,70,0.4)}
    .btn-ghost{background:rgba(255,255,255,0.1);border:1.5px solid rgba(255,255,255,0.3);color:#fff;padding:14px 28px;border-radius:10px;text-decoration:none;font-weight:600;font-size:16px}
    .content{padding:72px 48px;max-width:860px;margin:0 auto}.content h2{font-size:clamp(20px,2.8vw,28px);font-weight:900;color:var(--bleu);margin-bottom:16px;letter-spacing:-0.3px}.content h3{font-size:18px;font-weight:800;color:var(--bleu);margin:32px 0 12px}.content p{font-size:15px;color:var(--sous);line-height:1.8;margin-bottom:16px}.content ul{margin:12px 0 16px 20px;display:flex;flex-direction:column;gap:8px}.content ul li{font-size:15px;color:var(--sous);line-height:1.6}
    .highlights{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px;margin:32px 0}.highlight-card{background:var(--gris);border-radius:12px;padding:20px;border-left:3px solid var(--rouge)}.highlight-card strong{display:block;font-size:15px;font-weight:800;color:var(--bleu);margin-bottom:6px}.highlight-card span{font-size:13px;color:var(--sous);line-height:1.5}
    .related{background:var(--gris);padding:48px;border-radius:16px;margin-top:48px}.related h3{font-size:16px;font-weight:800;color:var(--bleu);margin-bottom:16px}.related-links{display:flex;flex-wrap:wrap;gap:10px}.related-links a{background:#fff;border:1px solid var(--gris2);border-radius:8px;padding:8px 16px;font-size:13px;font-weight:600;color:var(--bleu);text-decoration:none;transition:all 0.15s}.related-links a:hover{border-color:var(--rouge);color:var(--rouge)}
    .cta-section{background:linear-gradient(135deg,#c0303c 0%,#8b0000 100%);padding:64px 48px;text-align:center}.cta-section h2{color:#fff;font-size:clamp(22px,3.5vw,36px);font-weight:900;margin-bottom:12px}.cta-section p{color:rgba(255,255,255,0.82);font-size:16px;max-width:480px;margin:0 auto 28px;line-height:1.6}
    .tel-cards{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}.tel-card{background:rgba(255,255,255,0.14);border:1.5px solid rgba(255,255,255,0.3);border-radius:12px;padding:16px 32px;text-decoration:none}.tel-card span{display:block;color:rgba(255,255,255,0.7);font-size:11px;font-weight:600;letter-spacing:1px;text-transform:uppercase;margin-bottom:3px}.tel-card strong{color:#fff;font-size:clamp(20px,3vw,30px);font-weight:900}
    footer{background:#0b1120;padding:40px 48px 24px}.fbot{text-align:center;font-size:13px;color:rgba(255,255,255,0.3)}.fbot a{color:rgba(255,255,255,0.5);text-decoration:none}.fbot a:hover{color:#60c5f7}
    @media(max-width:768px){header{padding:0 20px}.hero{padding:60px 20px}.content{padding:48px 20px}.cta-section{padding:48px 20px}.related{padding:28px 20px}footer{padding:28px 20px 16px}}
'@

function New-SeoPage {
    param($t, $c)
    $fileName = "$($t.prefix)-$($c.slug).html"
    $url = "https://laurasbn.github.io/entreprise-btp/$fileName"
    $citySlug = $c.slug

    $addrClean = $c.addr -replace '&[a-z]+;', '' -replace '&#[0-9]+;', ''
    $cityClean = $c.name -replace '&[a-z]+;', '' -replace '&#[0-9]+;', ''

    $jsonld = '{"@context":"https://schema.org","@type":"LocalBusiness","name":"Atelier PACA — ' + $t.jsonNom + ' ' + $cityClean + '","description":"' + $t.jsonDesc + ' à ' + $cityClean + '.","url":"' + $url + '","telephone":"+33492141414","address":{"@type":"PostalAddress","streetAddress":"' + $addrClean + '","addressLocality":"' + $cityClean + '","postalCode":"' + $c.cp + '","addressRegion":"Alpes-Maritimes","addressCountry":"FR"},"aggregateRating":{"@type":"AggregateRating","ratingValue":"4.9","reviewCount":"166","bestRating":"5"},"areaServed":"' + $cityClean + '"}'

    $metaDesc = $t.metaDescTpl -replace '%%CITY%%', $c.name -replace '%%CP%%', $c.cp
    $metaKw = $t.kwTpl -replace '%%CITY%%', $c.name
    $p1 = $t.p1Tpl -replace '%%CITY%%', $c.name
    $p2 = $t.p2Tpl -replace '%%CITY%%', $c.name
    $servH3 = $t.servH3 -replace '%%CITY%%', $c.name
    $zoneH3 = $t.zoneH3 -replace '%%CITY%%', $c.name
    $zoneP = $t.zonePTpl -replace '%%CITY%%', $c.name -replace '%%AREA%%', $c.area

    $serviceItems = ($t.services | ForEach-Object { "    <li>$_</li>" }) -join "`n"

    $hl1d = "Agence &agrave; $($c.name)"

    $html = @"
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$($t.jsonNom) $($c.name) | Atelier PACA &mdash; $($t.metaSub)</title>
  <meta name="description" content="$metaDesc" />
  <meta name="keywords" content="$metaKw" />
  <meta name="robots" content="index, follow" />
  <link rel="canonical" href="$url" />
  <meta property="og:title" content="$($t.jsonNom) $($c.name) | Atelier PACA" />
  <meta property="og:description" content="$metaDesc" />
  <script type="application/ld+json">
  $jsonld
  </script>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet" />
  <style>
$CSS
  </style>
</head>
<body>

<header>
  <a href="index.html" class="logo">
    <div class="logo-icon">AP</div>
    <div class="logo-nom">Atelier <span>PACA</span></div>
  </a>
  <div class="header-right">
    <a href="tel:0492141414" class="header-tel">&#128222; 04 92 14 14 14</a>
    <a href="index.html#contact" class="btn-devis-h">Devis gratuit</a>
  </div>
</header>

<section class="hero">
  <p class="breadcrumb"><a href="index.html">Accueil</a> &rsaquo; <a href="index.html#services">$($t.breadcrumb)</a> &rsaquo; $($c.name)</p>
  <div class="hero-pill">$($t.pill) &mdash; $($c.name) $($c.cp) &mdash; 7j/7</div>
  <h1>$($t.h1r.Split('&')[0].Trim()) &agrave; <em>$($c.name)</em><br/>$(($t.h1r -replace '^[^&]*', '').TrimStart('&').TrimStart())</h1>
  <p class="hero-sub">$($t.heroSub)</p>
  <div class="hero-btns">
    <a href="tel:0492141414" class="btn-rouge">&#128222; Urgence &mdash; 04 92 14 14 14</a>
    <a href="index.html#contact" class="btn-ghost">Devis gratuit</a>
  </div>
</section>

<div class="content">
  <h2>$($t.h2) $($c.name) &mdash; $($t.metaSub)</h2>
  <p>$p1</p>
  <p>$($c.intro)</p>
  <p>$p2</p>

  <div class="highlights">
    <div class="highlight-card"><strong>$($t.hl1t)</strong><span>$hl1d</span></div>
    <div class="highlight-card"><strong>$($t.hl2t)</strong><span>$($t.hl2d)</span></div>
    <div class="highlight-card"><strong>$($t.hl3t)</strong><span>$($t.hl3d)</span></div>
    <div class="highlight-card"><strong>$($t.hl4t)</strong><span>$($t.hl4d)</span></div>
  </div>

  <h3>$servH3</h3>
  <ul>
$serviceItems
  </ul>

  <h3>$zoneH3</h3>
  <p>$zoneP</p>

  <div class="related">
    <h3>$($t.relH3)</h3>
    <div class="related-links">
      <a href="index.html">&#8592; Retour &agrave; l&rsquo;accueil</a>
      $($t.relLinks)
      <a href="index.html#services">Tous nos services</a>
    </div>
  </div>
</div>

<section class="cta-section">
  <h2>$($t.ctaEmoji) $($t.ctaUrgence) $($c.name) ?</h2>
  <p>$($t.ctaPara)</p>
  <div class="tel-cards">
    <a href="tel:0492141414" class="tel-card"><span>T&eacute;l&eacute;phone fixe</span><strong>04 92 14 14 14</strong></a>
    <a href="tel:0677203752" class="tel-card"><span>Mobile</span><strong>06 77 20 37 52</strong></a>
  </div>
</section>

<footer>
  <div class="fbot">
    &copy; 2026 Atelier PACA &mdash; $($t.jsonNom) $($c.name) &mdash;
    <a href="index.html">Retour &agrave; l&rsquo;accueil</a> &mdash;
    $($c.shortAddr)
  </div>
</footer>

</body>
</html>
"@
    return @{ FileName = $fileName; Html = $html }
}

$count = 0
foreach ($t in $TRADES) {
    foreach ($c in $CITIES) {
        $result = New-SeoPage $t $c
        $fn = $result.FileName
        if ($EXISTING -contains $fn) {
            Write-Host "SKIP (exists): $fn"
            continue
        }
        $path = Join-Path (Get-Location) $fn
        [System.IO.File]::WriteAllText($path, $result.Html, [System.Text.Encoding]::UTF8)
        Write-Host "CREATED: $fn"
        $count++
    }
}
Write-Host ""
Write-Host "Done: $count files created."
