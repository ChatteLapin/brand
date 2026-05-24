// ChatteLapin 事業者基本情報 (= data/business-info.yaml) の型定義
//
// 用途: brand/site/src/pages/index.astro + en/index.astro で参照される
// 事業者 master データを厳格に型化。
//
// yaml 構造方針: 翻訳が必要な値は { ja, en } のネスト、 言語不問の固有値
// (= ブランド名 / 日付 / 数値 / URL) は scalar 維持。

export interface LocalizedString {
  ja: string;
  en: string;
}

export interface BusinessInfo {
  name: LocalizedString;
  brand_name: string;
  brand_display: LocalizedString;
  founded_date: string;
  business_form: LocalizedString;
  industry: LocalizedString;
  tax: {
    office: LocalizedString;
    filing_type: LocalizedString;
    deduction_jpy: number;
    filing_method: LocalizedString;
    notes: LocalizedString;
  };
  github: {
    org: string;
    url: string;
  };
  site: {
    official_url: string;
    contact_url: string;
    status: LocalizedString;
  };
}
