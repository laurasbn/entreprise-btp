# Generateur de pages SEO "metier x ville" pour Atelier PACA
# Couvre les 26 villes du brief (14 en 06 + 12 en 83) x 6 metiers.
# Les fichiers deja presents sur le disque ne sont PAS ecrases (Test-Path),
# ce qui preserve les pages premium deja redigees a la main.
Set-Location "C:\Users\s_mic\entreprise-btp-site"

# --- Decodage entites HTML -> vrais caracteres UTF-8 (pour le JSON-LD) ---
function Dec($s) {
  if ($null -eq $s) { return '' }
  $s = $s -replace '&eacute;', [char]0x00E9 -replace '&Eacute;', [char]0x00C9 `
          -replace '&egrave;', [char]0x00E8 -replace '&agrave;', [char]0x00E0 `
          -replace '&ccedil;', [char]0x00E7 -replace '&euml;',  [char]0x00EB `
          -replace '&ocirc;',  [char]0x00F4 -replace '&icirc;', [char]0x00EE `
          -replace '&acirc;',  [char]0x00E2 -replace '&ucirc;', [char]0x00FB `
          -replace '&ecirc;',  [char]0x00EA -replace '&iuml;',  [char]0x00EF `
          -replace '&ugrave;', [char]0x00F9 -replace '&rsquo;', "'" `
          -replace '&mdash;',  [char]0x2014 -replace '&ndash;', [char]0x2013 `
          -replace '&nbsp;', ' ' -replace '&amp;', '&'
  $s = $s -replace '<[^>]+>', '' -replace '&[a-zA-Z]+;', '' -replace '&#[0-9]+;', ''
  return $s.Trim()
}

# --- Villes : agence = adresse de l'agence la plus proche (convention du site) ---
$CITIES = @(
  # ----- Alpes-Maritimes (06) -----
  @{slug='nice';name='Nice';jname='Nice';cp='06000';addr='34, av. Georges Cl&eacute;menceau';area="Vieux-Nice, Cimiez, Fabron, Saint-Isidore, l'Ariane, Riquier et Saint-Augustin";intro="Nice, capitale de la C&ocirc;te d'Azur et chef-lieu des Alpes-Maritimes, compte plus de 350 000 habitants r&eacute;partis dans des quartiers aux profils tr&egrave;s vari&eacute;s."}
  @{slug='cannes';name='Cannes';jname='Cannes';cp='06400';addr='5 Rue Boucicaut';area='Cannes centre, La Croisette, La Bocca, La Californie et Le Suquet';intro="Cannes, mondialement connue pour son Festival du Film, est aussi une ville &agrave; fort tissu r&eacute;sidentiel et h&ocirc;telier o&ugrave; chaque urgence devient critique en haute saison."}
  @{slug='antibes';name='Antibes';jname='Antibes';cp='06600';addr='48, chemin des Autrichiens';area="Antibes centre, Juan-les-Pins, Sophia-Antipolis et le Cap d'Antibes";intro="Antibes Juan-les-Pins combine centre historique m&eacute;di&eacute;val, technop&ocirc;le de Sophia-Antipolis et plages prist&eacute;es des Alpes-Maritimes."}
  @{slug='grasse';name='Grasse';jname='Grasse';cp='06130';addr='24, avenue Mathias Duval';area='Grasse centre, Saint-Jacques, La Paoute et Plan-de-Grasse';intro='Grasse, capitale mondiale du parfum, est une commune des hauteurs au territoire &eacute;tendu et aux nombreux hameaux.'}
  @{slug='cagnes-sur-mer';name='Cagnes-sur-Mer';jname='Cagnes-sur-Mer';cp='06800';addr='9, rue Pasteur';area='Cagnes-sur-Mer, Cros-de-Cagnes, Haut-de-Cagnes et la vall&eacute;e du Var';intro='Cagnes-sur-Mer, entre Nice et Antibes, allie station baln&eacute;aire, village m&eacute;di&eacute;val perch&eacute; et zones r&eacute;sidentielles.'}
  @{slug='le-cannet';name='Le Cannet';jname='Le Cannet';cp='06110';addr='32 Chemin l&rsquo;Olivet';area='Le Cannet, Rocheville, Cannes La Bocca et Mougins';intro='Le Cannet est une commune r&eacute;sidentielle surplombant Cannes, r&eacute;put&eacute;e pour son vieux village et ses quartiers pavillonnaires.'}
  @{slug='vallauris';name='Vallauris';jname='Vallauris';cp='06220';addr='48, chemin des Autrichiens';area='Vallauris, Golfe-Juan, Super-Cannes et les hauteurs';intro="Vallauris Golfe-Juan, cit&eacute; des potiers et de la c&eacute;ramique, est une station baln&eacute;aire vivante entre Antibes et Cannes."}
  @{slug='mandelieu-la-napoule';name='Mandelieu-la-Napoule';jname='Mandelieu-la-Napoule';cp='06210';addr='5 Rue Boucicaut';area='Mandelieu, La Napoule, Capitou et Cannes-Marina';intro="Mandelieu-la-Napoule, ville du mimosa, est une station baln&eacute;aire de l'ouest cannois dot&eacute;e de plusieurs ports de plaisance."}
  @{slug='menton';name='Menton';jname='Menton';cp='06500';addr='34, av. Georges Cl&eacute;menceau';area='Menton centre, Garavan, Carnol&egrave;s et les hauteurs';intro="Menton, la perle de la France, est une ville fronti&egrave;re avec l'Italie c&eacute;l&egrave;bre pour ses citrons et ses jardins."}
  @{slug='mougins';name='Mougins';jname='Mougins';cp='06250';addr='5 Rue Boucicaut';area='Mougins village, Tournamy, Font de l&rsquo;Orme et la p&eacute;riph&eacute;rie de Sophia-Antipolis';intro="Mougins, village perch&eacute; r&eacute;put&eacute; pour sa gastronomie, compte de nombreux quartiers r&eacute;sidentiels haut de gamme."}
  @{slug='villeneuve-loubet';name='Villeneuve-Loubet';jname='Villeneuve-Loubet';cp='06270';addr='9, rue Pasteur';area='Villeneuve-Loubet village, Marina Baie des Anges et les Hauts-de-Vaugrenier';intro="Villeneuve-Loubet, entre Cagnes-sur-Mer et Antibes, est c&eacute;l&egrave;bre pour la Marina Baie des Anges et ses plages."}
  @{slug='vence';name='Vence';jname='Vence';cp='06140';addr='9, rue Pasteur';area='Vence centre historique, La Sine et Saint-Michel';intro="Vence, cit&eacute; m&eacute;di&eacute;vale de l'arri&egrave;re-pays ni&ccedil;ois, est la porte des Baous et un secteur r&eacute;sidentiel pris&eacute;."}
  @{slug='carros';name='Carros';jname='Carros';cp='06510';addr='34, av. Georges Cl&eacute;menceau';area='Carros-le-Neuf, Carros village, le Plan de Carros et la zone industrielle';intro="Carros, dans la vall&eacute;e du Var, abrite l'une des plus importantes zones industrielles des Alpes-Maritimes."}
  # ----- Var (83) -----
  @{slug='saint-raphael';name='Saint-Rapha&euml;l';jname='Saint-Rapha&euml;l';cp='83700';addr='81, rue Waldeck Rousseau';area='Saint-Rapha&euml;l centre, Valescure, Boulouris, Agay et Le Dramont';intro="Saint-Rapha&euml;l, station baln&eacute;aire au pied de l'Est&eacute;rel et jumelle de Fr&eacute;jus, s'&eacute;tend sur un vaste littoral."}
  @{slug='frejus';name='Fr&eacute;jus';jname='Fr&eacute;jus';cp='83600';addr='81, rue Waldeck Rousseau';area='Fr&eacute;jus centre, Fr&eacute;jus-Plage, Saint-Aygulf et Port-Fr&eacute;jus';intro="Fr&eacute;jus, cit&eacute; romaine au c&oelig;ur de l'Est&eacute;rel, est une station baln&eacute;aire majeure de l'est varois."}
  @{slug='toulon';name='Toulon';jname='Toulon';cp='83000';addr='81, rue Waldeck Rousseau';area='Toulon centre, Le Mourillon, La Rode, Saint-Jean-du-Var et Pont-du-Las';intro="Toulon, pr&eacute;fecture du Var et grand port militaire de la M&eacute;diterran&eacute;e, est une m&eacute;tropole de pr&egrave;s de 180 000 habitants."}
  @{slug='draguignan';name='Draguignan';jname='Draguignan';cp='83300';addr='81, rue Waldeck Rousseau';area='Draguignan centre, Les Collettes et Le Plan';intro="Draguignan, sous-pr&eacute;fecture du Var, est la capitale de la Dracenie au c&oelig;ur de l'arri&egrave;re-pays varois."}
  @{slug='hyeres';name='Hy&egrave;res';jname='Hy&egrave;res';cp='83400';addr='81, rue Waldeck Rousseau';area='Hy&egrave;res centre, Hy&egrave;res-Plage, Giens et La Capte';intro="Hy&egrave;res, la cit&eacute; des palmiers, s'&eacute;tend de la presqu'&icirc;le de Giens aux &icirc;les d'Or, &agrave; l'est de Toulon."}
  @{slug='la-seyne-sur-mer';name='La Seyne-sur-Mer';jname='La Seyne-sur-Mer';cp='83500';addr='81, rue Waldeck Rousseau';area='La Seyne centre, Les Sablettes, Tamaris et Berthe';intro="La Seyne-sur-Mer, deuxi&egrave;me ville de la m&eacute;tropole toulonnaise, fait face &agrave; la rade de Toulon."}
  @{slug='la-garde';name='La Garde';jname='La Garde';cp='83130';addr='81, rue Waldeck Rousseau';area='La Garde centre, La Planquette et Sainte-Marguerite';intro="La Garde, aux portes de Toulon, est une ville r&eacute;sidentielle et universitaire dynamique du Var."}
  @{slug='six-fours-les-plages';name='Six-Fours-les-Plages';jname='Six-Fours-les-Plages';cp='83140';addr='81, rue Waldeck Rousseau';area='Six-Fours centre, Le Brusc et La Coudouli&egrave;re';intro="Six-Fours-les-Plages, station baln&eacute;aire entre Toulon et Bandol, est pris&eacute;e pour ses plages et le cap Sici&eacute;."}
  @{slug='sanary-sur-mer';name='Sanary-sur-Mer';jname='Sanary-sur-Mer';cp='83110';addr='81, rue Waldeck Rousseau';area='Sanary centre, le port et Portissol';intro="Sanary-sur-Mer, port de p&ecirc;che typiquement proven&ccedil;al, s&eacute;duit entre Bandol et Six-Fours."}
  @{slug='brignoles';name='Brignoles';jname='Brignoles';cp='83170';addr='81, rue Waldeck Rousseau';area='Brignoles centre et La Burli&egrave;re';intro="Brignoles, sous-pr&eacute;fecture au c&oelig;ur du Var, est la capitale de la Provence Verte."}
  @{slug='saint-maximin-la-sainte-baume';name='Saint-Maximin-la-Sainte-Baume';jname='Saint-Maximin-la-Sainte-Baume';cp='83470';addr='81, rue Waldeck Rousseau';area='Saint-Maximin centre et le quartier de la basilique';intro="Saint-Maximin-la-Sainte-Baume, ville de la Provence Verte, est c&eacute;l&egrave;bre pour sa basilique gothique."}
  @{slug='bandol';name='Bandol';jname='Bandol';cp='83150';addr='81, rue Waldeck Rousseau';area='Bandol centre, le port et Ren&eacute;cros';intro="Bandol, station baln&eacute;aire r&eacute;put&eacute;e pour son vignoble AOC, dispose d'un port de plaisance anim&eacute;."}
)

# --- Metiers ---
$LABELS = @{ 'climatisation'='Climatisation'; 'plombier'='Plombier'; 'electricien'='&Eacute;lectricien'; 'chauffagiste'='Chauffagiste'; 'serrurier'='Serrurier'; 'volets-roulants'='Volets' }

$TRADES = @(
  @{
    prefix='climatisation'; jsonNom='Climatisation'; titleNom='Climatisation'; hub='climatisation.html'; img='service-climatisation.jpg'
    breadcrumb='Climatisation'; pillIcon='snowflake'; pillTxt='Installateur climatisation'
    h1main='Installation &amp; D&eacute;pannage'; heroSub='Installation de climatiseurs split, multi-split et gainables, entretien et d&eacute;pannage. Devis gratuit sous 2h, techniciens qualifi&eacute;s 7j/7.'
    h2='Sp&eacute;cialiste climatisation &agrave;'; metaSub='Installation Split &amp; D&eacute;pannage'
    ctaIcon='snowflake'; ctaTitle='Installez votre climatisation &agrave;'; ctaPara='Devis gratuit sous 2h &mdash; techniciens qualifi&eacute;s disponibles 7j/7.'
    metaDescTpl="Climatisation &agrave; %%CITY%% (%%CP%%) : installation split, multi-split, entretien et d&eacute;pannage. Atelier PACA 4,9/5 &mdash; 166 avis Google. Devis gratuit, intervention rapide &agrave; %%CITY%% et ses environs."
    kwTpl='climatisation %%CITY%%, installateur climatisation %%CITY%%, pose climatiseur %%CITY%%, d&eacute;pannage clim %%CITY%%, installation split %%CITY%%'
    jsonDesc='Installation et d&eacute;pannage climatisation'
    p1Tpl="Avec des &eacute;t&eacute;s de plus en plus chauds sur la C&ocirc;te d'Azur, un climatiseur r&eacute;versible est devenu indispensable &agrave; %%CITY%%. Atelier PACA met &agrave; votre disposition des techniciens qualifi&eacute;s, bas&eacute;s localement, pour l'installation, l'entretien et le d&eacute;pannage de climatisation &agrave; %%CITY%% et dans tout le secteur."
    p2Tpl="Nos techniciens ma&icirc;trisent les contraintes locales de %%CITY%% : r&egrave;glements d'urbanisme, copropri&eacute;t&eacute;s et b&acirc;timents anciens. Nous intervenons en appartement, maison individuelle comme en local commercial. Devis d&eacute;taill&eacute;, transparent et envoy&eacute; sous 2h, sans engagement."
    servH3='Nos prestations climatisation &agrave;'
    services=@(
      '<strong>Pose de climatiseur split mural</strong> &mdash; installation propre et discr&egrave;te, respect des copropri&eacute;t&eacute;s',
      '<strong>Climatisation r&eacute;versible</strong> &mdash; confort chaud en hiver, frais en &eacute;t&eacute;',
      '<strong>Syst&egrave;me multi-split</strong> &mdash; climatisez plusieurs pi&egrave;ces avec une seule unit&eacute; ext&eacute;rieure',
      '<strong>Climatiseur gainable</strong> &mdash; installation invisible, int&eacute;gration parfaite au b&acirc;ti',
      '<strong>Entretien et maintenance</strong> &mdash; contrat annuel, nettoyage et recharge de fluide',
      '<strong>D&eacute;pannage</strong> &mdash; panne en plein &eacute;t&eacute; ? Intervention rapide pour vous rafra&icirc;chir'
    )
    hl=@(@{t='Agence locale';d='Techniciens bas&eacute;s pr&egrave;s de chez vous'},@{t='4,9/5 Google';d='166 avis v&eacute;rifi&eacute;s'},@{t='Devis sous 2h';d='R&eacute;ponse garantie sous 2 heures'},@{t='Marques partenaires';d='Daikin, Mitsubishi, Atlantic, Hitachi'})
    others=@('chauffagiste','electricien')
  }
  @{
    prefix='plombier'; jsonNom='Plombier'; titleNom='Plombier'; hub='plomberie.html'; img='service-plomberie.jpg'
    breadcrumb='Plomberie'; pillIcon='wrench'; pillTxt='Plombier'
    h1main='D&eacute;pannage &amp; Urgence'; heroSub="Fuite d'eau, canalisation bouch&eacute;e, chauffe-eau en panne ? Nos plombiers interviennent en urgence 24h/24 et 7j/7."
    h2='Plombier d&rsquo;urgence &agrave;'; metaSub='Fuite Eau &amp; Urgence 24h/24'
    ctaIcon='alert-triangle'; ctaTitle='Urgence plomberie &agrave;'; ctaPara='Un plombier disponible maintenant &mdash; intervention 24h/24 et 7j/7.'
    metaDescTpl="Plombier &agrave; %%CITY%% (%%CP%%) : d&eacute;pannage fuite d'eau, canalisation bouch&eacute;e, chauffe-eau, urgence 24h/24. Atelier PACA 4,9/5 &mdash; 166 avis Google. Intervention rapide &agrave; %%CITY%% et ses environs."
    kwTpl='plombier %%CITY%%, d&eacute;pannage plomberie %%CITY%%, fuite eau %%CITY%%, plombier urgence %%CITY%%, canalisation bouch&eacute;e %%CITY%%, chauffe-eau %%CITY%%'
    jsonDesc='D&eacute;pannage plomberie'
    p1Tpl="Une fuite d'eau, une canalisation bloqu&eacute;e ou un chauffe-eau en panne peuvent vite tourner &agrave; l'urgence &agrave; %%CITY%%. Atelier PACA met &agrave; votre disposition des plombiers qualifi&eacute;s, disponibles 24 heures sur 24, tous les jours de l'ann&eacute;e, dans tout le secteur de %%CITY%%."
    p2Tpl="Nous savons qu'une urgence plomberie ne pr&eacute;vient pas. C'est pourquoi nos &eacute;quipes &agrave; %%CITY%% s'engagent &agrave; vous r&eacute;pondre imm&eacute;diatement et &agrave; intervenir dans les meilleurs d&eacute;lais. Nos tarifs vous sont communiqu&eacute;s avant toute intervention, sans mauvaise surprise."
    servH3='Nos interventions plomberie &agrave;'
    services=@(
      "<strong>Fuite d'eau</strong> &mdash; d&eacute;tection et r&eacute;paration rapide, limitation des d&eacute;g&acirc;ts des eaux",
      '<strong>Canalisation bouch&eacute;e</strong> &mdash; d&eacute;bouchage par haute pression ou furet m&eacute;canique',
      '<strong>Chauffe-eau &eacute;lectrique et gaz</strong> &mdash; d&eacute;pannage, entretien, remplacement',
      '<strong>Robinetterie et sanitaires</strong> &mdash; remplacement robinets, mitigeurs, WC',
      '<strong>Salle de bain</strong> &mdash; installation douche, baignoire, WC suspendu',
      '<strong>Plomberie de r&eacute;novation</strong> &mdash; remise aux normes, nouveaux r&eacute;seaux'
    )
    hl=@(@{t='Urgence 24h/24';d='Un plombier disponible nuit et jour'},@{t='4,9/5 Google';d='166 avis v&eacute;rifi&eacute;s'},@{t='Tarif transparent';d='Devis communiqu&eacute; avant intervention'},@{t='Intervention rapide';d='Plombier dispatch&eacute; au plus vite'})
    others=@('electricien','serrurier')
  }
  @{
    prefix='electricien'; jsonNom='Electricien'; titleNom='Electricien'; hub='electricite.html'; img='service-electricite.jpg'
    breadcrumb='&Eacute;lectricit&eacute;'; pillIcon='zap'; pillTxt='&Eacute;lectricien'
    h1main='D&eacute;pannage &amp; Installation'; heroSub='Panne &eacute;lectrique, mise aux normes, tableau &eacute;lectrique, prises ? Nos &eacute;lectriciens interviennent rapidement 24h/24 et 7j/7.'
    h2='&Eacute;lectricien qualifi&eacute; &agrave;'; metaSub='Panne &Eacute;lectrique &amp; Mise aux Normes'
    ctaIcon='alert-triangle'; ctaTitle='Urgence &eacute;lectrique &agrave;'; ctaPara='Un &eacute;lectricien disponible maintenant &mdash; intervention rapide 24h/24.'
    metaDescTpl="Electricien &agrave; %%CITY%% (%%CP%%) : d&eacute;pannage panne &eacute;lectrique, mise aux normes tableau, installation prises. Atelier PACA 4,9/5 &mdash; 166 avis Google. Intervention rapide 24h/24 &agrave; %%CITY%%."
    kwTpl='electricien %%CITY%%, d&eacute;pannage &eacute;lectrique %%CITY%%, panne &eacute;lectrique %%CITY%%, tableau &eacute;lectrique %%CITY%%, mise aux normes &eacute;lectrique %%CITY%%'
    jsonDesc='D&eacute;pannage et installation &eacute;lectrique'
    p1Tpl="Panne de courant, disjoncteur qui saute, installation &eacute;lectrique v&eacute;tuste ou non conforme &agrave; %%CITY%% ? Atelier PACA met &agrave; votre disposition des &eacute;lectriciens qualifi&eacute;s, disponibles 24h/24, intervenant dans tous les secteurs de %%CITY%% et ses environs."
    p2Tpl="Nos &eacute;lectriciens &agrave; %%CITY%% traitent aussi bien les urgences nocturnes que les travaux planifi&eacute;s : mise aux normes NF C 15-100, r&eacute;novation compl&egrave;te d'installation, ajout de circuits. Nos devis sont d&eacute;taill&eacute;s et transmis avant toute intervention."
    servH3='Nos prestations &eacute;lectricit&eacute; &agrave;'
    services=@(
      '<strong>D&eacute;pannage panne &eacute;lectrique</strong> &mdash; diagnostic et remise en service rapide',
      '<strong>Tableau &eacute;lectrique</strong> &mdash; mise aux normes, remplacement, disjoncteurs diff&eacute;rentiels',
      '<strong>Prises et interrupteurs</strong> &mdash; ajout de circuits, d&eacute;placement de prises',
      '<strong>&Eacute;clairage LED</strong> &mdash; luminaires, spots encastr&eacute;s, &eacute;clairage ext&eacute;rieur',
      '<strong>Domotique</strong> &mdash; volets motoris&eacute;s, &eacute;clairage connect&eacute;, gestion d&rsquo;&eacute;nergie',
      '<strong>Mise aux normes NF C 15-100</strong> &mdash; conformit&eacute; pour location ou vente'
    )
    hl=@(@{t='Urgence 24h/24';d='Un &eacute;lectricien disponible nuit et jour'},@{t='4,9/5 Google';d='166 avis v&eacute;rifi&eacute;s'},@{t='Devis avant travaux';d='Tarification transparente'},@{t='NF C 15-100';d='Mise aux normes certifi&eacute;e'})
    others=@('plombier','chauffagiste')
  }
  @{
    prefix='chauffagiste'; jsonNom='Chauffagiste'; titleNom='Chauffagiste'; hub='chauffage.html'; img='service-chauffage.jpg'
    breadcrumb='Chauffage'; pillIcon='flame'; pillTxt='Chauffagiste'
    h1main='Chaudi&egrave;re &amp; Pompe &agrave; Chaleur'; heroSub='Panne de chaudi&egrave;re, entretien annuel, installation de pompe &agrave; chaleur ? Nos chauffagistes interviennent rapidement 24h/24 et 7j/7.'
    h2='Chauffagiste qualifi&eacute; &agrave;'; metaSub='Chaudi&egrave;re, PAC &amp; Entretien'
    ctaIcon='alert-triangle'; ctaTitle='Urgence chauffage &agrave;'; ctaPara='Un chauffagiste disponible rapidement &mdash; devis gratuit sous 2h.'
    metaDescTpl="Chauffagiste &agrave; %%CITY%% (%%CP%%) : d&eacute;pannage chaudi&egrave;re, entretien annuel, installation pompe &agrave; chaleur. Atelier PACA 4,9/5 &mdash; 166 avis Google. Intervention rapide 24h/24 &agrave; %%CITY%%."
    kwTpl='chauffagiste %%CITY%%, d&eacute;pannage chaudi&egrave;re %%CITY%%, entretien chaudi&egrave;re %%CITY%%, pompe &agrave; chaleur %%CITY%%, plombier chauffagiste %%CITY%%'
    jsonDesc='D&eacute;pannage et installation chauffage'
    p1Tpl="Chaudi&egrave;re en panne, radiateurs froids ou installation de chauffage &agrave; pr&eacute;voir &agrave; %%CITY%% ? Atelier PACA dispose d'une &eacute;quipe de chauffagistes qualifi&eacute;s, bas&eacute;e &agrave; proximit&eacute; de %%CITY%%, disponible 24h/24."
    p2Tpl="Bien que la C&ocirc;te d'Azur b&eacute;n&eacute;ficie d'un climat doux, un chauffage fiable reste indispensable &agrave; %%CITY%% en hiver. Nos techniciens interviennent sur tous types d'&eacute;quipements : chaudi&egrave;re gaz, fioul, pompe &agrave; chaleur et plancher chauffant."
    servH3='Nos prestations chauffage &agrave;'
    services=@(
      '<strong>D&eacute;pannage chaudi&egrave;re gaz et fioul</strong> &mdash; intervention d&rsquo;urgence pour remettre le chauffage en service',
      "<strong>Entretien annuel chaudi&egrave;re</strong> &mdash; nettoyage, r&eacute;glage, attestation d'entretien obligatoire",
      '<strong>Pompe &agrave; chaleur air/eau</strong> &mdash; installation et mise en service PAC r&eacute;versible',
      '<strong>Plancher chauffant</strong> &mdash; installation et d&eacute;pannage hydraulique',
      '<strong>Radiateurs et robinets thermostatiques</strong> &mdash; remplacement et &eacute;quilibrage du circuit',
      '<strong>Ballon eau chaude</strong> &mdash; d&eacute;pannage, d&eacute;tartrage et remplacement'
    )
    hl=@(@{t='Urgence 24h/24';d='Chauffagiste disponible rapidement'},@{t='4,9/5 Google';d='166 avis v&eacute;rifi&eacute;s'},@{t='Entretien annuel';d='Attestation officielle fournie'},@{t='Toutes marques';d='Daikin, Atlantic, De Dietrich...'})
    others=@('plombier','climatisation')
  }
  @{
    prefix='serrurier'; jsonNom='Serrurier'; titleNom='Serrurier'; hub='serrurerie.html'; img='service-serrurerie.jpg'
    breadcrumb='Serrurerie'; pillIcon='lock'; pillTxt='Serrurier'
    h1main='Ouverture Porte &amp; Urgence'; heroSub='Porte claqu&eacute;e, serrure bloqu&eacute;e, effraction ? Nos serruriers interviennent en urgence 24h/24 et 7j/7. Tarifs affich&eacute;s, sans mauvaise surprise.'
    h2='Serrurier d&rsquo;urgence &agrave;'; metaSub='Ouverture Porte &amp; Urgence 24h/24'
    ctaIcon='alert-triangle'; ctaTitle='Porte bloqu&eacute;e &agrave;'; ctaPara='Un serrurier qualifi&eacute; intervient dans les meilleurs d&eacute;lais, 24h/24 et 7j/7.'
    metaDescTpl="Serrurier &agrave; %%CITY%% (%%CP%%) : ouverture de porte claqu&eacute;e, changement de serrure, blindage. Atelier PACA 4,9/5 &mdash; 166 avis Google. Intervention urgente 24h/24 &agrave; %%CITY%%."
    kwTpl='serrurier %%CITY%%, ouverture porte %%CITY%%, serrurier urgence %%CITY%%, changement serrure %%CITY%%, serrurier 24h %%CITY%%'
    jsonDesc='Serrurier d&rsquo;urgence'
    p1Tpl="Vous &ecirc;tes bloqu&eacute; devant votre porte &agrave; %%CITY%% ? Serrure d&eacute;fectueuse ou tentative d'effraction ? Atelier PACA met &agrave; votre disposition des serruriers qualifi&eacute;s, disponibles 24 heures sur 24, tous les jours de l'ann&eacute;e."
    p2Tpl="Chez Atelier PACA, nous n'appliquons pas de tarifs abusifs, m&ecirc;me en urgence nocturne. Avant toute intervention &agrave; %%CITY%%, le co&ucirc;t estim&eacute; vous est communiqu&eacute; et vous restez libre de d&eacute;cider. Pour une ouverture de porte, nous privil&eacute;gions toujours les m&eacute;thodes non destructives."
    servH3='Nos prestations serrurerie &agrave;'
    services=@(
      '<strong>Ouverture de porte claqu&eacute;e</strong> &mdash; sans d&eacute;t&eacute;rioration si possible, m&eacute;thode douce privil&eacute;gi&eacute;e',
      '<strong>Changement de serrure</strong> &mdash; remplacement de cylindre ou serrure compl&egrave;te',
      '<strong>Blindage de porte</strong> &mdash; renforcement de la s&eacute;curit&eacute; de votre logement',
      '<strong>Apr&egrave;s effraction</strong> &mdash; s&eacute;curisation d&rsquo;urgence et remplacement rapide',
      '<strong>Serrure multipoints</strong> &mdash; installation de serrures 3 ou 5 points',
      '<strong>Digicodes et badges</strong> &mdash; contr&ocirc;le d&rsquo;acc&egrave;s pour copropri&eacute;t&eacute;s et locaux'
    )
    hl=@(@{t='Urgence 24h/24';d='Serrurier disponible nuit et jour'},@{t='4,9/5 Google';d='166 avis v&eacute;rifi&eacute;s'},@{t='Tarif transparent';d='Prix communiqu&eacute; avant intervention'},@{t='M&eacute;thode douce';d='Ouverture sans casse privil&eacute;gi&eacute;e'})
    others=@('plombier','volets-roulants')
  }
  @{
    prefix='volets-roulants'; jsonNom='Volets roulants'; titleNom='Volets roulants'; hub='volets-roulants.html'; img='service-volets.webp'
    breadcrumb='Volets roulants'; pillIcon='home'; pillTxt='Volets roulants'
    h1main='Installation &amp; D&eacute;pannage'; heroSub='Volet bloqu&eacute;, moteur HS, installation neuve ? Nos techniciens interviennent rapidement pour tous vos volets roulants, 7j/7.'
    h2='Sp&eacute;cialiste volets roulants &agrave;'; metaSub='Installation &amp; Motorisation'
    ctaIcon='home'; ctaTitle='Volet bloqu&eacute; &agrave;'; ctaPara='Devis gratuit sous 2h &mdash; techniciens qualifi&eacute;s disponibles 7j/7.'
    metaDescTpl="Volets roulants &agrave; %%CITY%% (%%CP%%) : installation, motorisation, d&eacute;pannage de volet bloqu&eacute;. Atelier PACA 4,9/5 &mdash; 166 avis Google. Techniciens qualifi&eacute;s &agrave; %%CITY%% et ses environs."
    kwTpl='volets roulants %%CITY%%, motorisation volets %%CITY%%, installation volets roulants %%CITY%%, r&eacute;paration volets %%CITY%%, volet bloqu&eacute; %%CITY%%'
    jsonDesc='Installation et d&eacute;pannage volets roulants'
    p1Tpl="Volet roulant bloqu&eacute;, lames ab&icirc;m&eacute;es ou motorisation &agrave; installer &agrave; %%CITY%% ? Atelier PACA dispose de techniciens sp&eacute;cialis&eacute;s dans les volets roulants, intervenant sur toute la commune de %%CITY%% et ses environs, 7 jours sur 7."
    p2Tpl="Que vous souhaitiez motoriser vos volets existants &agrave; %%CITY%%, installer des volets neufs ou r&eacute;parer un moteur Somfy ou Nice d&eacute;faillant, nos techniciens qualifi&eacute;s vous remettent un devis d&eacute;taill&eacute; et transparent sous 2h."
    servH3='Nos prestations volets roulants &agrave;'
    services=@(
      '<strong>Motorisation de volets</strong> &mdash; passage en &eacute;lectrique avec t&eacute;l&eacute;commande',
      '<strong>Installation de volets neufs</strong> &mdash; aluminium, PVC ou bois, sur mesure',
      '<strong>R&eacute;paration moteur Somfy / Nice / Came</strong> &mdash; d&eacute;pannage et remplacement',
      '<strong>Remplacement de lames</strong> &mdash; tablier ab&icirc;m&eacute; ou cass&eacute; r&eacute;par&eacute; rapidement',
      '<strong>Stores et bannes</strong> &mdash; installation et motorisation de stores ext&eacute;rieurs',
      '<strong>Domotique volets</strong> &mdash; int&eacute;gration box domotique, commande smartphone'
    )
    hl=@(@{t='Agence locale';d='Techniciens bas&eacute;s pr&egrave;s de chez vous'},@{t='4,9/5 Google';d='166 avis v&eacute;rifi&eacute;s'},@{t='Devis sous 2h';d='R&eacute;ponse garantie sous 2 heures'},@{t='Toutes marques';d='Somfy, Nice, Came, Bubendorff...'})
    others=@('serrurier','electricien')
  }
)

$CSS = @'
    *,*::before,*::after{margin:0;padding:0;box-sizing:border-box}
    :root{--rouge:#D4526A;--bleu:#1D3557;--gris:#F7F8FA;--gris2:#EEF0F3;--texte:#111827;--sous:#6B7280}
    html{scroll-behavior:smooth}body{font-family:'Inter',sans-serif;color:var(--texte);background:#fff;overflow-x:hidden}
    header{position:sticky;top:0;z-index:100;background:var(--bleu);height:66px;display:flex;align-items:center;justify-content:space-between;padding:0 48px;box-shadow:0 4px 20px rgba(0,0,0,0.25)}
    .logo{display:flex;align-items:center;gap:12px;text-decoration:none}.logo-icon{width:40px;height:40px;background:var(--rouge);border-radius:8px;display:flex;align-items:center;justify-content:center;font-weight:900;color:#fff;font-size:15px}.logo-nom{font-size:18px;font-weight:700;color:#fff}.logo-nom span{color:var(--rouge)}
    .header-right{display:flex;align-items:center;gap:16px}.header-tel{color:#fff;font-weight:700;font-size:15px;white-space:nowrap;text-decoration:none;display:inline-flex;align-items:center;gap:6px}.btn-devis-h{background:var(--rouge);color:#fff;font-weight:700;border-radius:8px;padding:8px 18px;text-decoration:none;font-size:14px}
    .hero{background:linear-gradient(135deg,#0a1628 0%,var(--bleu) 60%,#0a1628 100%);padding:80px 48px;text-align:center}
    .breadcrumb{font-size:13px;color:rgba(255,255,255,0.5);margin-bottom:20px}.breadcrumb a{color:rgba(255,255,255,0.6);text-decoration:none}
    .hero-pill{display:inline-flex;align-items:center;gap:8px;background:rgba(212,82,106,0.20);border:1px solid rgba(212,82,106,0.50);color:#f0a4b4;font-size:13px;font-weight:600;padding:5px 16px;border-radius:100px;margin-bottom:24px}
    .hero h1{color:#fff;font-size:clamp(28px,4.5vw,52px);font-weight:900;line-height:1.1;letter-spacing:-1px;margin-bottom:18px}.hero h1 em{color:#60c5f7;font-style:normal}
    .hero-sub{color:rgba(255,255,255,0.75);font-size:clamp(15px,1.6vw,17px);max-width:560px;margin:0 auto 32px;line-height:1.7}
    .hero-btns{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}
    .btn-rouge{background:var(--rouge);color:#fff;padding:14px 28px;border-radius:10px;text-decoration:none;font-weight:700;font-size:16px;box-shadow:0 4px 18px rgba(212,82,106,0.4);display:inline-flex;align-items:center;gap:8px}
    .btn-ghost{background:rgba(255,255,255,0.1);border:1.5px solid rgba(255,255,255,0.3);color:#fff;padding:14px 28px;border-radius:10px;text-decoration:none;font-weight:600;font-size:16px}
    .content{padding:72px 48px;max-width:860px;margin:0 auto}.content h2{font-size:clamp(20px,2.8vw,28px);font-weight:900;color:var(--bleu);margin-bottom:16px;letter-spacing:-0.3px}.content h3{font-size:18px;font-weight:800;color:var(--bleu);margin:32px 0 12px}.content p{font-size:15px;color:var(--sous);line-height:1.8;margin-bottom:16px}.content ul{margin:12px 0 16px 20px;display:flex;flex-direction:column;gap:8px}.content ul li{font-size:15px;color:var(--sous);line-height:1.6}
    .highlights{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px;margin:32px 0}.highlight-card{background:var(--gris);border-radius:12px;padding:20px;border-left:3px solid var(--rouge)}.highlight-card strong{display:block;font-size:15px;font-weight:800;color:var(--bleu);margin-bottom:6px}.highlight-card span{font-size:13px;color:var(--sous);line-height:1.5}
    .related{background:var(--gris);padding:48px;border-radius:16px;margin-top:48px}.related h3{font-size:16px;font-weight:800;color:var(--bleu);margin-bottom:16px;display:flex;align-items:center;gap:8px}.related-links{display:flex;flex-wrap:wrap;gap:10px}.related-links a{background:#fff;border:1px solid var(--gris2);border-radius:8px;padding:8px 16px;font-size:13px;font-weight:600;color:var(--bleu);text-decoration:none;transition:all 0.15s}.related-links a:hover{border-color:var(--rouge);color:var(--rouge)}
    .cta-section{background:linear-gradient(135deg,#c0303c 0%,#8b0000 100%);padding:64px 48px;text-align:center}.cta-section h2{color:#fff;font-size:clamp(22px,3.5vw,36px);font-weight:900;margin-bottom:12px;display:flex;align-items:center;justify-content:center;gap:10px}.cta-section p{color:rgba(255,255,255,0.82);font-size:16px;max-width:480px;margin:0 auto 28px;line-height:1.6}
    .tel-cards{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}.tel-card{background:rgba(255,255,255,0.14);border:1.5px solid rgba(255,255,255,0.3);border-radius:12px;padding:16px 32px;text-decoration:none}.tel-card span{display:block;color:rgba(255,255,255,0.7);font-size:11px;font-weight:600;letter-spacing:1px;text-transform:uppercase;margin-bottom:3px}.tel-card strong{color:#fff;font-size:clamp(20px,3vw,30px);font-weight:900}
    footer{background:#0b1120;padding:40px 48px 24px}.fbot{text-align:center;font-size:13px;color:rgba(255,255,255,0.3)}.fbot a{color:rgba(255,255,255,0.5);text-decoration:none}.fbot a:hover{color:#60c5f7}
    svg.lucide{display:inline-block;vertical-align:middle;flex-shrink:0;stroke-width:1.75;width:1em;height:1em}
    .hero-pill svg.lucide{width:14px;height:14px}.highlight-card svg.lucide{width:16px;height:16px;color:var(--rouge)}.header-tel svg.lucide{width:16px;height:16px}.btn-rouge svg.lucide{width:18px;height:18px}.cta-section h2 svg.lucide{width:32px;height:32px}.related h3 svg.lucide{width:16px;height:16px;color:var(--rouge)}
    @media(max-width:768px){header{padding:0 20px}.hero{padding:60px 20px}.content{padding:48px 20px}.cta-section{padding:48px 20px}.related{padding:28px 20px}footer{padding:28px 20px 16px}}
'@

function New-SeoPage {
  param($t, $c)
  $url   = "https://atelierpaca.fr/$($t.prefix)-$($c.slug).html"
  $city  = $c.name
  $cp    = $c.cp

  $metaDesc = ($t.metaDescTpl -replace '%%CITY%%', $city) -replace '%%CP%%', $cp
  $metaKw   = $t.kwTpl  -replace '%%CITY%%', $city
  $p1       = $t.p1Tpl  -replace '%%CITY%%', $city
  $p2       = $t.p2Tpl  -replace '%%CITY%%', $city

  # JSON-LD : vrais caracteres UTF-8 (pas d'entites HTML)
  $jName = Dec $t.jsonNom
  $jCity = Dec $c.jname
  $jDesc = Dec $t.jsonDesc
  $jAddr = Dec $c.addr
  $jsonld = '{"@context":"https://schema.org","@type":"LocalBusiness","name":"Atelier PACA - ' + $jName + ' ' + $jCity + '","description":"' + $jDesc + ' a ' + $jCity + ' (' + $cp + ').","url":"' + $url + '","telephone":"+33492141414","email":"atelierpaca.06@gmail.com","address":{"@type":"PostalAddress","streetAddress":"' + $jAddr + '","addressLocality":"' + $jCity + '","postalCode":"' + $cp + '","addressRegion":"' + $(if($cp -like '06*'){'Alpes-Maritimes'}else{'Var'}) + '","addressCountry":"FR"},"aggregateRating":{"@type":"AggregateRating","ratingValue":"4.9","reviewCount":"166","bestRating":"5"},"areaServed":{"@type":"City","name":"' + $jCity + '"}}'

  $serviceItems = ($t.services | ForEach-Object { "    <li>$_</li>" }) -join "`n"
  $hlCards = ($t.hl | ForEach-Object { "    <div class=`"highlight-card`"><strong>$($_.t)</strong><span>$($_.d)</span></div>" }) -join "`n"

  # Maillage interne : 2 autres metiers dans la meme ville + meme metier a Nice/Cannes
  $rel  = ''
  foreach ($o in $t.others) { $rel += "      <a href=`"$o-$($c.slug).html`">$($LABELS[$o]) $city</a>`n" }
  $rel += "      <a href=`"$($t.prefix)-nice.html`">$($t.titleNom) Nice</a>`n"
  $rel += "      <a href=`"$($t.prefix)-cannes.html`">$($t.titleNom) Cannes</a>`n"
  $rel += "      <a href=`"$($t.hub)`">$($t.breadcrumb) &mdash; en savoir plus</a>"

  $html = @"
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$($t.titleNom) $city | Atelier PACA &mdash; $($t.metaSub)</title>
  <meta name="description" content="$metaDesc" />
  <meta name="keywords" content="$metaKw" />
  <meta name="robots" content="index, follow" />
  <link rel="canonical" href="$url" />
  <meta property="og:type" content="website" />
  <meta property="og:locale" content="fr_FR" />
  <meta property="og:site_name" content="Atelier PACA" />
  <meta property="og:title" content="$($t.titleNom) $city | Atelier PACA" />
  <meta property="og:description" content="$metaDesc" />
  <meta property="og:url" content="$url" />
  <meta property="og:image" content="https://atelierpaca.fr/images/$($t.img)" />
  <link rel="icon" type="image/svg+xml" href="favicon.svg" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="$($t.titleNom) $city | Atelier PACA" />
  <meta name="twitter:description" content="$metaDesc" />
  <meta name="twitter:image" content="https://atelierpaca.fr/images/$($t.img)" />
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
    <a href="tel:0492141414" class="header-tel"><i data-lucide="phone"></i> 04 92 14 14 14</a>
    <a href="index.html#contact" class="btn-devis-h">Devis gratuit</a>
  </div>
</header>

<section class="hero">
  <p class="breadcrumb"><a href="index.html">Accueil</a> &rsaquo; <a href="$($t.hub)">$($t.breadcrumb)</a> &rsaquo; $city</p>
  <div class="hero-pill"><i data-lucide="$($t.pillIcon)"></i> $($t.pillTxt) &mdash; $city $cp &mdash; 7j/7</div>
  <h1>$($t.titleNom) &agrave; <em>$city</em><br/>$($t.h1main)</h1>
  <p class="hero-sub">$($t.heroSub)</p>
  <div class="hero-btns">
    <a href="tel:0492141414" class="btn-rouge"><i data-lucide="phone"></i> Urgence &mdash; 04 92 14 14 14</a>
    <a href="index.html#contact" class="btn-ghost">Devis gratuit</a>
  </div>
</section>

<div class="content">
  <h2>$($t.h2) $city &mdash; $($t.metaSub)</h2>
  <p>$p1</p>
  <p>$($c.intro)</p>
  <p>$p2</p>

  <div class="highlights">
$hlCards
  </div>

  <h3>$($t.servH3) $city</h3>
  <ul>
$serviceItems
  </ul>

  <h3>Zone d&rsquo;intervention : $city et ses environs</h3>
  <p>Nous intervenons dans tout le secteur de $city : $($c.area). Pour toute demande, appelez le <strong>04 92 14 14 14</strong> ou demandez votre devis gratuit en ligne.</p>

  <div class="related">
    <h3><i data-lucide="map-pin"></i> Autres services &agrave; $city et alentours</h3>
    <div class="related-links">
      <a href="index.html">&#8592; Retour &agrave; l&rsquo;accueil</a>
$rel
      <a href="index.html#services">Tous nos services</a>
    </div>
  </div>
</div>

<section class="cta-section">
  <h2><i data-lucide="$($t.ctaIcon)"></i> $($t.ctaTitle) $city ?</h2>
  <p>$($t.ctaPara)</p>
  <div class="tel-cards">
    <a href="tel:0492141414" class="tel-card"><span>T&eacute;l&eacute;phone fixe</span><strong>04 92 14 14 14</strong></a>
    <a href="tel:0677203752" class="tel-card"><span>Mobile</span><strong>06 77 20 37 52</strong></a>
  </div>
</section>

<footer>
  <div class="fbot">
    &copy; 2026 Atelier PACA &mdash; $($t.titleNom) $city &mdash;
    <a href="index.html">Retour &agrave; l&rsquo;accueil</a> &mdash;
    $($c.addr), $cp $city (agence la plus proche)
  </div>
</footer>

<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
<script>lucide.createIcons();</script>
</body>
</html>
"@
  return $html
}

$enc = New-Object System.Text.UTF8Encoding $false
$created = 0; $skipped = 0
foreach ($t in $TRADES) {
  foreach ($c in $CITIES) {
    $fn = "$($t.prefix)-$($c.slug).html"
    $path = Join-Path (Get-Location) $fn
    if (Test-Path $path) { Write-Host "SKIP (existe): $fn"; $skipped++; continue }
    [System.IO.File]::WriteAllText($path, (New-SeoPage $t $c), $enc)
    Write-Host "CREE: $fn"; $created++
  }
}
Write-Host ""
Write-Host "Termine : $created pages creees, $skipped ignorees (deja presentes)."
