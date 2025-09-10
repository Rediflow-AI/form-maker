enum Currencies {
  usd,
  eur,
  gbp,
  jpy,
  cad,
  aud,
  chf,
  cny,
  inr,
  krw,
  sgd,
  hkd,
  nzd,
  sek,
  nok,
  dkk,
  pln,
  czk,
  huf,
  rub,
  try_,
  brl,
  zar,
  mxn,
  aed,
  sar,
  egp,
  kwd,
  qar,
  bhd,
  omr,
  jod,
  lbp,
  mad,
  dzd,
  tnd,
  iqd,
  lyd,
  pkr,
  bdt,
  lkr,
  npr,
  afn,
  mmk,
  thb,
  vnd,
  idr,
  myr,
  php,
  clp,
  pen,
  cop,
  ars,
  uyu,
  bob,
  pyg,
  gyd,
  srd,
  fkp,
  shp,
  ggp,
  jep,
  imp,
  tvd,
  aud_tv,
  nzd_ck,
  nzd_nu,
  nzd_pn,
  nzd_tk,
  usd_as,
  usd_gu,
  usd_mp,
  usd_pr,
  usd_um,
  usd_vi,
  eur_ad,
  eur_at,
  eur_be,
  eur_cy,
  eur_de,
  eur_ee,
  eur_es,
  eur_fi,
  eur_fr,
  eur_gr,
  eur_ie,
  eur_it,
  eur_lt,
  eur_lu,
  eur_lv,
  eur_mc,
  eur_me,
  eur_mt,
  eur_nl,
  eur_pt,
  eur_si,
  eur_sk,
  eur_sm,
  eur_va,
  eur_xk,
}

extension CurrencyExtension on Currencies {
  String get displayName {
    switch (this) {
      case Currencies.usd:
        return 'US Dollar';
      case Currencies.eur:
        return 'Euro';
      case Currencies.gbp:
        return 'British Pound';
      case Currencies.jpy:
        return 'Japanese Yen';
      case Currencies.cad:
        return 'Canadian Dollar';
      case Currencies.aud:
        return 'Australian Dollar';
      case Currencies.chf:
        return 'Swiss Franc';
      case Currencies.cny:
        return 'Chinese Yuan';
      case Currencies.inr:
        return 'Indian Rupee';
      case Currencies.krw:
        return 'South Korean Won';
      default:
        return name.toUpperCase();
    }
  }

  String get symbol {
    switch (this) {
      case Currencies.usd:
        return '\$';
      case Currencies.eur:
        return '€';
      case Currencies.gbp:
        return '£';
      case Currencies.jpy:
        return '¥';
      case Currencies.cad:
        return 'C\$';
      case Currencies.aud:
        return 'A\$';
      case Currencies.chf:
        return 'CHF';
      case Currencies.cny:
        return '¥';
      case Currencies.inr:
        return '₹';
      case Currencies.krw:
        return '₩';
      default:
        return name.toUpperCase();
    }
  }
}
