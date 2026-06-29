// SEO INVISIBLE UNIQUEMENT — Atelier PACA
// Modifie seulement : <title> (inchangé), meta description, JSON-LD (head), alt du logo existant, sitemap.
// N'AJOUTE AUCUNE image, AUCUN lien, ne touche RIEN de visible dans le corps de page.
// Usage : node seo-invisible.js [--apply]
const fs = require('fs'), path = require('path');
const ROOT = __dirname;
const APPLY = process.argv.includes('--apply');
const TODAY = '2026-06-29';

const villes = ['antibes','bandol','brignoles','cagnes-sur-mer','cannes','carros','draguignan','frejus','grasse','hyeres','la-garde','la-seyne-sur-mer','le-cannet','mandelieu-la-napoule','menton','mougins','nice','saint-laurent-du-var','saint-maximin-la-sainte-baume','saint-raphael','sanary-sur-mer','six-fours-les-plages','toulon','vallauris','vence','villeneuve-loubet'];
const dispo = {'antibes':'Antibes','bandol':'Bandol','brignoles':'Brignoles','cagnes-sur-mer':'Cagnes-sur-Mer','cannes':'Cannes','carros':'Carros','draguignan':'Draguignan','frejus':'Fréjus','grasse':'Grasse','hyeres':'Hyères','la-garde':'La Garde','la-seyne-sur-mer':'La Seyne-sur-Mer','le-cannet':'Le Cannet','mandelieu-la-napoule':'Mandelieu-la-Napoule','menton':'Menton','mougins':'Mougins','nice':'Nice','saint-laurent-du-var':'Saint-Laurent-du-Var','saint-maximin-la-sainte-baume':'Saint-Maximin-la-Sainte-Baume','saint-raphael':'Saint-Raphaël','sanary-sur-mer':'Sanary-sur-Mer','six-fours-les-plages':'Six-Fours-les-Plages','toulon':'Toulon','vallauris':'Vallauris','vence':'Vence','villeneuve-loubet':'Villeneuve-Loubet'};
const geo = {'antibes':[43.5808,7.1239],'bandol':[43.1356,5.7536],'brignoles':[43.4055,6.0619],'cagnes-sur-mer':[43.6644,7.1489],'cannes':[43.5528,7.0174],'carros':[43.7906,7.1881],'draguignan':[43.5403,6.4669],'frejus':[43.4332,6.7370],'grasse':[43.6586,6.9225],'hyeres':[43.1206,6.1286],'la-garde':[43.1256,6.0103],'la-seyne-sur-mer':[43.1006,5.8831],'le-cannet':[43.5769,7.0194],'mandelieu-la-napoule':[43.5461,6.9386],'menton':[43.7765,7.5000],'mougins':[43.6005,7.0006],'nice':[43.7102,7.2620],'saint-laurent-du-var':[43.6678,7.1869],'saint-maximin-la-sainte-baume':[43.4528,5.8628],'saint-raphael':[43.4253,6.7686],'sanary-sur-mer':[43.1175,5.8019],'six-fours-les-plages':[43.0931,5.8378],'toulon':[43.1242,5.9280],'vallauris':[43.5803,7.0536],'vence':[43.7236,7.1119],'villeneuve-loubet':[43.6583,7.1219]};
const varSet = new Set(['bandol','brignoles','draguignan','frejus','hyeres','la-garde','la-seyne-sur-mer','saint-maximin-la-sainte-baume','saint-raphael','sanary-sur-mer','six-fours-les-plages','toulon']);

const metiers = {
  'climatisation':   {label:'Climatisation', type:'HVACBusiness', img:'service-climatisation.jpg', svc:'Installation de climatisation', svcType:'Climatisation', meta:v=>`Climatisation à ${v} : installation, entretien et dépannage par Atelier PACA. Devis gratuit sous 24h, 4,9/5 sur Google.`},
  'plombier':        {label:'Plombier', type:'Plumber', img:'service-plomberie.jpg', svc:'Dépannage plomberie', svcType:'Plomberie', meta:v=>`Plombier à ${v} : dépannage fuite, débouchage et rénovation par Atelier PACA. Intervention rapide, devis gratuit, 4,9/5.`},
  'electricien':     {label:'Électricien', type:'Electrician', img:'service-electricite.jpg', svc:"Travaux d'électricité", svcType:'Électricité', meta:v=>`Électricien à ${v} : mise aux normes, dépannage et tableau électrique. Atelier PACA, devis gratuit, 4,9/5 sur Google.`},
  'serrurier':       {label:'Serrurier', type:'Locksmith', img:'service-serrurerie.jpg', svc:'Dépannage serrurerie', svcType:'Serrurerie', meta:v=>`Serrurier à ${v} : ouverture de porte, changement de serrure et blindage. Atelier PACA, intervention 24h/24, 4,9/5.`},
  'chauffagiste':    {label:'Chauffagiste', type:'HVACBusiness', img:'service-chauffage.jpg', svc:'Installation chauffage', svcType:'Chauffage', meta:v=>`Chauffagiste à ${v} : installation, entretien et dépannage chauffage. Atelier PACA, devis gratuit sous 24h, 4,9/5.`},
  'volets-roulants': {label:'Volets roulants', type:'HomeAndConstructionBusiness', img:'service-volets.webp', svc:'Pose de volets roulants', svcType:'Volets roulants', meta:v=>`Volets roulants à ${v} : pose, motorisation et dépannage par Atelier PACA. Devis gratuit sous 24h, 4,9/5 sur Google.`}
};
const metierOrder = ['climatisation','plombier','electricien','serrurier','chauffagiste','volets-roulants'];
const ldRe = /<script type="application\/ld\+json">\s*(\{[\s\S]*?\})\s*<\/script>/;
const logoRe = /(<img src="images\/logo-paca-blanc\.png" alt=")[^"]*(")/;

let warnMeta=[], warnSchema=[], warnLogo=[], cityCount=0, hubCount=0, instCount=0;

function setMeta(html, meta, file){ if(meta.length>155) warnMeta.push(`${file} (${meta.length})`); return html.replace(/(<meta name="description" content=")[^"]*(")/, (m,p1,p2)=>p1+meta+p2); }

// ---------- PAGES VILLES ----------
for (const prefix of metierOrder) {
  const cfg = metiers[prefix];
  for (const v of villes) {
    const file = `${prefix}-${v}.html`;
    if (file === 'climatisation-cannes.html') continue; // témoin déjà validé
    const fp = path.join(ROOT, file);
    if (!fs.existsSync(fp)) continue;
    let html = fs.readFileSync(fp, 'utf8');
    const vd = dispo[v]; const [lat,lng] = geo[v];

    html = setMeta(html, cfg.meta(vd), file);

    const m = html.match(ldRe);
    if (!m) warnSchema.push(file);
    else {
      const j = m[1];
      const name = (j.match(/"name":"((?:[^"\\]|\\.)*)"/)||[])[1] || `Atelier PACA — ${cfg.label} ${vd}`;
      const desc = (j.match(/"description":"((?:[^"\\]|\\.)*)"/)||[])[1] || `${cfg.svc} à ${vd}.`;
      const url  = (j.match(/"url":"([^"]*)"/)||[])[1] || `https://atelierpaca.fr/${file}`;
      const dept = varSet.has(v) ? 'Var' : 'Alpes-Maritimes';
      const addr = (j.match(/"address":(\{[^}]*\})/)||[])[1] || `{"@type":"PostalAddress","addressLocality":"${vd}","addressRegion":"${dept}","addressCountry":"FR"}`;
      const agg  = (j.match(/"aggregateRating":(\{[^}]*\})/)||[])[1] || `{"@type":"AggregateRating","ratingValue":"4.9","reviewCount":"166","bestRating":"5"}`;
      const nj = `{"@context":"https://schema.org","@type":["LocalBusiness","${cfg.type}"],"@id":"${url}#business","name":"${name}","description":"${desc}","url":"${url}","telephone":"+33492141414","image":"https://atelierpaca.fr/images/${cfg.img}","priceRange":"€€","address":${addr},"geo":{"@type":"GeoCoordinates","latitude":${lat},"longitude":${lng}},"areaServed":{"@type":"City","name":"${vd}"},"openingHoursSpecification":{"@type":"OpeningHoursSpecification","dayOfWeek":["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],"opens":"00:00","closes":"23:59"},"aggregateRating":${agg},"makesOffer":{"@type":"Offer","itemOffered":{"@type":"Service","name":"${cfg.svc} à ${vd}","serviceType":"${cfg.svcType}"}}}`;
      html = html.replace(ldRe, () => `<script type="application/ld+json">\n  ${nj}\n  </script>`);
    }

    // alt du LOGO existant uniquement (invisible)
    if (logoRe.test(html)) html = html.replace(logoRe, (m,p1,p2)=>`${p1}Atelier PACA &mdash; ${cfg.label} &agrave; ${vd}${p2}`);
    else warnLogo.push(file);

    if (APPLY) fs.writeFileSync(fp, html, 'utf8');
    cityCount++;
  }
}

// ---------- PAGES HUB (meta + schema Service enrichi + alt logo) ----------
const hubs = {
  'climatisation.html':   {label:'Climatisation', svcType:'Climatisation', meta:'Climatisation dans les Alpes-Maritimes et le Var : installation, entretien et dépannage par Atelier PACA. Devis gratuit, 4,9/5 sur Google.'},
  'plomberie.html':       {label:'Plomberie', svcType:'Plomberie', meta:'Plombier dans le 06 et le Var : dépannage fuite, débouchage et rénovation salle de bain. Atelier PACA, intervention rapide, 4,9/5.'},
  'electricite.html':     {label:'Électricité', svcType:'Électricité', meta:'Électricien dans le 06 et le Var : mise aux normes, dépannage et tableau électrique. Atelier PACA, devis gratuit, 4,9/5.'},
  'serrurerie.html':      {label:'Serrurerie', svcType:'Serrurerie', meta:'Serrurier dans le 06 et le Var : ouverture de porte, changement de serrure et blindage. Atelier PACA, intervention 24h/24, 4,9/5.'},
  'chauffage.html':       {label:'Chauffage', svcType:'Chauffage', meta:'Chauffagiste dans le 06 et le Var : installation, entretien et dépannage chauffage. Atelier PACA, devis gratuit sous 24h, 4,9/5.'},
  'volets-roulants.html': {label:'Volets roulants', svcType:'Volets roulants', meta:'Volets roulants dans le 06 et le Var : pose, motorisation et dépannage par Atelier PACA. Devis gratuit, 4,9/5 sur Google.'}
};
for (const [file, cfg] of Object.entries(hubs)) {
  const fp = path.join(ROOT, file);
  let html = fs.readFileSync(fp, 'utf8');
  html = setMeta(html, cfg.meta, file);
  const m = html.match(ldRe);
  if (!m) warnSchema.push(file);
  else {
    const j = m[1];
    const name = (j.match(/"name":"((?:[^"\\]|\\.)*)"/)||[])[1] || `${cfg.label} — Atelier PACA`;
    const desc = (j.match(/"description":"((?:[^"\\]|\\.)*)"/)||[])[1] || `${cfg.label} dans les Alpes-Maritimes et le Var.`;
    // Service enrichi : provider avec note + priceRange, zone 06 + Var (invisible)
    const nj = `{"@context":"https://schema.org","@type":"Service","serviceType":"${cfg.svcType}","name":"${name}","provider":{"@type":"LocalBusiness","name":"Atelier PACA","telephone":"+33492141414","url":"https://atelierpaca.fr/","priceRange":"€€","aggregateRating":{"@type":"AggregateRating","ratingValue":"4.9","reviewCount":"166","bestRating":"5"}},"areaServed":[{"@type":"AdministrativeArea","name":"Alpes-Maritimes"},{"@type":"AdministrativeArea","name":"Var"}],"description":"${desc}"}`;
    html = html.replace(ldRe, () => `<script type="application/ld+json">\n  ${nj}\n  </script>`);
  }
  if (logoRe.test(html)) html = html.replace(logoRe, (m,p1,p2)=>`${p1}Atelier PACA &mdash; ${cfg.label} dans le 06 et le Var${p2}`);
  if (APPLY) fs.writeFileSync(fp, html, 'utf8');
  hubCount++;
}

// ---------- PAGES INSTITUTIONNELLES (meta uniquement) ----------
const inst = {
  'index.html':        'Atelier PACA : climatisation, plomberie, électricité, chauffage et serrurerie dans le 06 et le Var. Devis gratuit, 4,9/5 sur Google, 24h/24.',
  'a-propos.html':     'Atelier PACA, artisans qualifiés depuis 2015 dans le 06 et le Var : climatisation, plomberie, électricité, chauffage. Garantie décennale, 4,9/5.',
  'faq.html':          'FAQ Atelier PACA : délais, devis gratuit, zones couvertes, tarifs, garanties et urgences 24h/24 dans les Alpes-Maritimes et le Var.',
  'contact.html':      'Contactez Atelier PACA : devis gratuit, téléphone 04 92 14 14 14, formulaire en ligne et 8 agences dans le 06 et le Var.',
  'blog.html':         'Blog Atelier PACA : conseils clim, plomberie, électricité et chauffage dans les Alpes-Maritimes et le Var. Nouveaux articles à venir.',
  'marques.html':      'Atelier PACA installe les grandes marques de climatisation dans le 06 et le Var : Daikin, Mitsubishi, Atlantic, Hitachi. Techniciens certifiés.',
  'realisations.html': 'Réalisations Atelier PACA : climatisation, plomberie, électricité et volets roulants dans le 06 et le Var. 4,9/5 sur 166 avis Google.'
};
for (const [file, meta] of Object.entries(inst)) {
  const fp = path.join(ROOT, file);
  if (!fs.existsSync(fp)) continue;
  let html = fs.readFileSync(fp, 'utf8');
  html = setMeta(html, meta, file);
  if (APPLY) fs.writeFileSync(fp, html, 'utf8');
  instCount++;
}

// ---------- SITEMAP ----------
{
  const fp = path.join(ROOT, 'sitemap.xml');
  let xml = fs.readFileSync(fp, 'utf8');
  xml = xml.replace(/<lastmod>[^<]*<\/lastmod>/g, `<lastmod>${TODAY}</lastmod>`);
  if (APPLY) fs.writeFileSync(fp, xml, 'utf8');
}

console.log(`Mode : ${APPLY ? 'APPLIQUÉ' : 'SIMULATION'}`);
console.log(`Villes: ${cityCount} (témoin exclue) | Hubs: ${hubCount} | Institutionnelles: ${instCount} | sitemap: lastmod -> ${TODAY}`);
if (warnMeta.length)   console.log(`⚠ Meta > 155 (${warnMeta.length}): ${warnMeta.join(', ')}`);
if (warnSchema.length) console.log(`⚠ Schema introuvable (${warnSchema.length}): ${warnSchema.join(', ')}`);
if (warnLogo.length)   console.log(`⚠ Logo introuvable (${warnLogo.length}): ${warnLogo.join(', ')}`);
if (!warnMeta.length && !warnSchema.length && !warnLogo.length) console.log('✅ Aucun avertissement.');
