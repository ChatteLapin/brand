// ChatteLapin 公式サイト i18n 辞書の型定義
//
// 用途:
// - data/i18n/{ja,en}.yaml の構造を厳密に型化、 page 側で `i18n.products_talent.foo` を
//   タイポすると tsc エラーで早期検出
// - ja/en で 1:1 mirror 構造を維持するため、 同一 interface を両方に当てる
//
// env.d.ts の declare module '*/data/i18n/{ja,en}.yaml' でこの型を yaml import に紐付ける。
//
// shime レポート (2026-05-24) 残課題 #3 = yaml 型安全化、 への対応。

// ============================================================
// 共通 sub-type
// ============================================================

export interface LinkItem {
  label: string;
  href: string;
  text: string;
  note: string;
  external: boolean;
}

export interface LinksSection {
  num: string;
  marginalia: string;
  title: string;
  items: LinkItem[];
}

export interface CalloutBlock {
  label: string;
  text: string;
}

// ============================================================
// hero
// ============================================================

export interface HeroDict {
  eyebrow: { num: string; label: string };
  title: { line1: string; line2: string; line3: string };
  lede: string;
  meta: {
    founded_label: string;
    founded_value: string;
    trade_label: string;
    trade_value: string;
    domicile_label: string;
    domicile_value: string;
  };
  logo_alt: string;
  scroll_label: string;
  scroll_aria: string;
}

// ============================================================
// header
// ============================================================

export interface HeaderDict {
  brand_aria: string;
  nav_aria: string;
  switch_locale_aria: string;
  switch_locale_label: string;
  switch_locale_suggested_tooltip: string;
  nav: {
    mission: string;
    products: string;
    about: string;
    contact: string;
  };
}

// ============================================================
// footer
// ============================================================

export interface FooterDict {
  colophon_label: string;
  colophon_text: string;
  nav_label_navigation: string;
  nav_label_elsewhere: string;
  nav_aria: string;
  github_org: string;
  issues_link: string;
  copy_name: string;
  rights: string;
}

// ============================================================
// mission
// ============================================================

export interface BridgeItem {
  num: string;
  title: string;
  text: string;
}

export interface MissionDict {
  num: string;
  marginalia: string;
  title: string;
  lede: string;
  bridge: {
    talent: BridgeItem;
    volt: BridgeItem;
    business: BridgeItem;
    brand: BridgeItem;
  };
}

// ============================================================
// about
// ============================================================

export interface AboutDict {
  num: string;
  marginalia: string;
  eyebrow: string;
  title: string;
  mission_frame: {
    label: string;
    text: string;
    body_1: string;
    body_2: string;
  };
  overview: {
    subtitle: string;
    paragraph_1: string;
    paragraph_2: string;
    paragraph_3: string;
  };
  legacy: {
    subtitle: string;
    intro: string;
    quote_text: string;
    quote_attribution: string;
    inheritance: string;
  };
  profile: {
    subtitle: string;
    intro: string;
    bio: string[];
    lift: string;
  };
  info: {
    subtitle: string;
    labels: {
      name: string;
      founded: string;
      form: string;
      industry: string;
      tax_office: string;
      github_org: string;
    };
  };
}

// ============================================================
// products (= top page の products section)
// ============================================================

export interface ProductCardSummary {
  name: string;
  tagline: string;
  badge: string;
}

export interface ProductsDict {
  num: string;
  marginalia: string;
  eyebrow: string;
  title: string;
  lede: string;
  divider_label: string;
  subtitle: string;
  satellite_lede: string;
  cards: {
    talent: ProductCardSummary;
    volt: ProductCardSummary;
    business: ProductCardSummary;
    brand: ProductCardSummary;
  };
}

// ============================================================
// product page (= /products/* + /en/products/*)
// product page 共通の base + 個別 section を組み合わせる
// ============================================================

export interface ProductLayout {
  title: string;
  description: string;
}

export interface ProductHeaderBase {
  eyebrow: string;
  title: string;
  tagline: string;
}

// 各 product で meta の追加 key が違うため、 page 別に header type を分ける

// --- products_business ---

export interface ProductBusinessHeader extends ProductHeaderBase {
  meta: {
    field_label: string;
    field_value: string;
    status_label: string;
    status_value: string;
    policy_label: string;
    policy_value: string;
  };
}

export interface ProductPipelineLayer {
  num: string;
  title: string;
  text: string;
}

export interface ProductsBusinessDict {
  layout: ProductLayout;
  breadcrumb_label: string;
  header: ProductBusinessHeader;
  position: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
    paragraph_3: string;
  };
  pipeline: {
    num: string;
    marginalia: string;
    title: string;
    layers: ProductPipelineLayer[];
  };
  progress: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
  };
  stack: {
    num: string;
    marginalia: string;
    title: string;
    items: string[];
  };
  links: LinksSection;
}

// --- products_volt ---

export interface ProductVoltHeader extends ProductHeaderBase {
  meta: {
    field_label: string;
    field_value: string;
    status_label: string;
    status_value: string;
    bridge_label: string;
    bridge_value: string;
  };
}

export interface ProductVoltRelay {
  from: string;
  to: string;
}

export interface ProductsVoltDict {
  layout: ProductLayout;
  breadcrumb_label: string;
  header: ProductVoltHeader;
  purpose: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
  };
  bridge: {
    num: string;
    marginalia: string;
    title: string;
    paragraph: string;
    relays: ProductVoltRelay[];
  };
  stack: {
    num: string;
    marginalia: string;
    title: string;
    items: string[];
  };
  operation: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
  };
  links: LinksSection;
}

// --- products_brand ---

export interface ProductBrandHeader extends ProductHeaderBase {
  meta: {
    field_label: string;
    field_value: string;
    status_label: string;
    status_value: string;
    access_label: string;
    access_value: string;
  };
}

export interface ProductBrandAssetItem {
  title: string;
  text: string;
  future?: boolean;
}

export interface ProductsBrandDict {
  layout: ProductLayout;
  breadcrumb_label: string;
  header: ProductBrandHeader;
  position: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
    paragraph_3: string;
  };
  assets: {
    num: string;
    marginalia: string;
    title: string;
    items: ProductBrandAssetItem[];
  };
  operation: {
    num: string;
    marginalia: string;
    title: string;
    paragraph: string;
  };
  links: LinksSection;
}

// --- products_talent ---

export interface ProductTalentHeader extends ProductHeaderBase {
  meta: {
    field_label: string;
    field_value: string;
    distribution_label: string;
    distribution_value: string;
    status_label: string;
    status_value: string;
  };
}

export interface TalentPrincipleItem {
  num: string;
  title: string;
  text: string;
}

export interface TalentAxisItem {
  num: string;
  title: string;
  text: string;
}

export interface TalentCurriculumRow {
  area: string;
  body: string;
}

export interface TalentVocationItem {
  tag: string;
  title: string;
  text: string;
}

export interface TalentSafetyStandard {
  name: string;
  href: string;
  text: string;
}

export interface TalentLanguageSample {
  scene: string;
  ja: string;
  en: string;
}

export interface TalentMarketRow {
  area: string;
  titles: string;
  gap: string;
}

export interface TalentRoadmapRow {
  version: string;
  content: string;
  time: string;
}

export interface TalentDistributionItem {
  num: string;
  title: string;
  text: string;
}

export interface ProductsTalentDict {
  layout: ProductLayout;
  breadcrumb_label: string;
  header: ProductTalentHeader;
  overview: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
    callout: CalloutBlock;
  };
  etymology: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
    callout: CalloutBlock;
  };
  principles: {
    num: string;
    marginalia: string;
    title: string;
    lede: string;
    items: TalentPrincipleItem[];
  };
  axes: {
    num: string;
    marginalia: string;
    title: string;
    items: TalentAxisItem[];
    lift_text: string;
  };
  curriculum: {
    num: string;
    marginalia: string;
    title: string;
    paragraph: string;
    categories: { tag: string; title: string; text: string }[];
    disciplines: {
      subtitle: string;
      intro: string;
      items: { tag: string; title: string; text: string }[];
    };
    lift_text: string;
    table: { head_area: string; head_body: string };
    rows: TalentCurriculumRow[];
    rigor: {
      subtitle: string;
      intro: string;
      items: { tag: string; title: string; text: string }[];
    };
  };
  vocations: {
    num: string;
    marginalia: string;
    title: string;
    paragraph: string;
    items: TalentVocationItem[];
    lift_text: string;
  };
  safety: {
    num: string;
    marginalia: string;
    title: string;
    check_items: string[];
    subtitle: string;
    subtitle_paragraph: string;
    table: { head_standard: string; head_area: string };
    standards: TalentSafetyStandard[];
  };
  language: {
    num: string;
    marginalia: string;
    title: string;
    paragraph_1: string;
    paragraph_2: string;
    table: { head_scene: string; head_ja: string; head_en: string };
    samples: TalentLanguageSample[];
    paragraph_quiet: string;
  };
  market: {
    num: string;
    marginalia: string;
    title: string;
    paragraph: string;
    table: { head_area: string; head_titles: string; head_gap: string };
    rows: TalentMarketRow[];
    lift_text: string;
  };
  continuity: {
    num: string;
    marginalia: string;
    title: string;
    paragraph: string;
    items: string[];
  };
  roadmap: {
    num: string;
    marginalia: string;
    title: string;
    table: { head_version: string; head_content: string; head_time: string };
    rows: TalentRoadmapRow[];
  };
  distribution: {
    num: string;
    marginalia: string;
    title: string;
    items: TalentDistributionItem[];
  };
  links: LinksSection;
}

// ============================================================
// contact
// ============================================================

export interface ContactDict {
  num: string;
  marginalia: string;
  eyebrow: string;
  title: string;
  lede: string;
  cta: { label: string; hint: string };
  fallback: string;
}

// ============================================================
// Top-level: I18nDict
// ============================================================

export interface I18nDict {
  hero: HeroDict;
  header: HeaderDict;
  footer: FooterDict;
  mission: MissionDict;
  about: AboutDict;
  products: ProductsDict;
  products_business: ProductsBusinessDict;
  products_volt: ProductsVoltDict;
  products_brand: ProductsBrandDict;
  products_talent: ProductsTalentDict;
  contact: ContactDict;
}
