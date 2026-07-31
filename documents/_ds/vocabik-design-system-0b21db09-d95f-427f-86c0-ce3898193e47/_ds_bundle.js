/* @ds-bundle: {"format":3,"namespace":"VocabikDesignSystem_0b21db","components":[{"name":"Avatar","sourcePath":"components/core/Avatar.jsx"},{"name":"Badge","sourcePath":"components/core/Badge.jsx"},{"name":"Button","sourcePath":"components/core/Button.jsx"},{"name":"IconButton","sourcePath":"components/core/IconButton.jsx"},{"name":"Input","sourcePath":"components/core/Input.jsx"},{"name":"ProgressBar","sourcePath":"components/core/ProgressBar.jsx"},{"name":"Skeleton","sourcePath":"components/core/Skeleton.jsx"},{"name":"StarRating","sourcePath":"components/core/StarRating.jsx"},{"name":"Switch","sourcePath":"components/core/Switch.jsx"},{"name":"Tag","sourcePath":"components/core/Tag.jsx"},{"name":"Toast","sourcePath":"components/core/Toast.jsx"},{"name":"CommunityReactions","sourcePath":"components/media/CommunityReactions.jsx"},{"name":"FilterChip","sourcePath":"components/media/FilterChip.jsx"},{"name":"LevelBadge","sourcePath":"components/media/LevelBadge.jsx"},{"name":"StatCard","sourcePath":"components/media/StatCard.jsx"},{"name":"VersionSelector","sourcePath":"components/media/VersionSelector.jsx"},{"name":"VideoCard","sourcePath":"components/media/VideoCard.jsx"}],"sourceHashes":{"components/core/Avatar.jsx":"95545da51b44","components/core/Badge.jsx":"aeed31d8cb27","components/core/Button.jsx":"2d3b25eb480a","components/core/IconButton.jsx":"9edb5505d9ed","components/core/Input.jsx":"d7657d8da1bf","components/core/ProgressBar.jsx":"60cdbd12a1fe","components/core/Skeleton.jsx":"a83ca5a07786","components/core/StarRating.jsx":"4dfc4fb31091","components/core/Switch.jsx":"ce199ec44d6c","components/core/Tag.jsx":"fb82d25d1236","components/core/Toast.jsx":"645292b94b62","components/media/CommunityReactions.jsx":"2a0adf5b604c","components/media/FilterChip.jsx":"acfb903db1c0","components/media/LevelBadge.jsx":"dde59b380847","components/media/StatCard.jsx":"ddd666b98531","components/media/VersionSelector.jsx":"fb9db726b01d","components/media/VideoCard.jsx":"9613914a16a8","ui_kits/app/AppData.js":"007a31cda717","ui_kits/app/ExerciseScreen.jsx":"d95702756886","ui_kits/app/HomeScreen.jsx":"e06a98e6c688","ui_kits/app/ProgressScreen.jsx":"152e295e2729","ui_kits/app/ScoreScreen.jsx":"e309061fc6ac"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.VocabikDesignSystem_0b21db = window.VocabikDesignSystem_0b21db || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/core/Avatar.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * User avatar. Premium users get a purple gradient ring + small badge.
 * Falls back to initials when no image is provided.
 */
function Avatar({
  src,
  name = '',
  size = 40,
  premium = false,
  style = {},
  ...rest
}) {
  const initials = name.trim().split(/\s+/).map(w => w[0]).slice(0, 2).join('').toUpperCase() || '?';
  const ringW = premium ? Math.max(2, Math.round(size * 0.06)) : 0;
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      position: 'relative',
      display: 'inline-flex',
      flex: '0 0 auto',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: size,
      height: size,
      borderRadius: 'var(--radius-full)',
      padding: ringW,
      background: premium ? 'linear-gradient(135deg, var(--purple-300), var(--purple-500))' : 'transparent',
      boxShadow: premium ? 'var(--glow-premium)' : 'none'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: '100%',
      height: '100%',
      borderRadius: 'var(--radius-full)',
      overflow: 'hidden',
      background: 'var(--surface-card-2)',
      color: 'var(--text-secondary)',
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--fw-bold)',
      fontSize: size * 0.4
    }
  }, src ? /*#__PURE__*/React.createElement("img", {
    src: src,
    alt: name,
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover'
    }
  }) : initials)), premium && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      bottom: -2,
      right: -2,
      width: size * 0.42,
      height: size * 0.42,
      minWidth: 16,
      minHeight: 16,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      borderRadius: 'var(--radius-full)',
      background: 'var(--premium)',
      border: '2px solid var(--surface-base)',
      color: '#fff',
      fontSize: size * 0.24,
      fontWeight: 700
    },
    "aria-label": "Premium"
  }, "\u2605"));
}
Object.assign(__ds_scope, { Avatar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Avatar.jsx", error: String((e && e.message) || e) }); }

// components/core/Badge.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Small status pill — NEW, PREMIUM, completion, counts, toned semantic chips.
 * For CEFR level badges use <LevelBadge> instead.
 */
function Badge({
  children,
  tone = 'neutral',
  size = 'md',
  soft = true,
  icon = null,
  style = {},
  ...rest
}) {
  const tones = {
    neutral: {
      fg: 'var(--text-secondary)',
      bg: 'var(--surface-card-2)',
      solidBg: 'var(--ink-600)'
    },
    accent: {
      fg: 'var(--accent)',
      bg: 'var(--accent-soft)',
      solidBg: 'var(--accent)',
      solidFg: 'var(--text-on-accent)'
    },
    premium: {
      fg: 'var(--premium)',
      bg: 'var(--premium-soft)',
      solidBg: 'var(--premium)',
      solidFg: '#fff'
    },
    success: {
      fg: 'var(--success)',
      bg: 'var(--success-soft)',
      solidBg: 'var(--success)',
      solidFg: '#04140C'
    },
    danger: {
      fg: 'var(--danger)',
      bg: 'var(--danger-soft)',
      solidBg: 'var(--danger)',
      solidFg: '#fff'
    },
    warning: {
      fg: 'var(--warning)',
      bg: 'var(--warning-soft)',
      solidBg: 'var(--warning)',
      solidFg: '#1A1203'
    },
    new: {
      fg: '#04140C',
      bg: 'var(--success)',
      solidBg: 'var(--success)',
      solidFg: '#04140C'
    }
  }[tone] || {};
  const sizes = {
    sm: {
      font: 'var(--text-2xs)',
      pad: '2px 7px',
      h: 18
    },
    md: {
      font: 'var(--text-xs)',
      pad: '3px 10px',
      h: 22
    },
    lg: {
      font: 'var(--text-sm)',
      pad: '5px 12px',
      h: 28
    }
  }[size];
  const solid = !soft || tone === 'new';
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 4,
      height: sizes.h,
      padding: sizes.pad,
      fontFamily: 'var(--font-body)',
      fontSize: sizes.font,
      fontWeight: 'var(--fw-bold)',
      letterSpacing: 'var(--ls-wider)',
      textTransform: 'uppercase',
      borderRadius: 'var(--radius-pill)',
      whiteSpace: 'nowrap',
      color: solid ? tones.solidFg || '#fff' : tones.fg,
      background: solid ? tones.solidBg : tones.bg,
      ...style
    }
  }, rest), icon, children);
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Badge.jsx", error: String((e && e.message) || e) }); }

// components/core/Button.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Vocabik primary button. Theme-aware, pill-shaped, 44px+ touch target.
 * Variants: primary (teal), secondary, ghost, premium (purple), destructive.
 */
function Button({
  children,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  disabled = false,
  loading = false,
  iconLeft = null,
  iconRight = null,
  style = {},
  ...rest
}) {
  const sizes = {
    sm: {
      height: 'var(--control-sm)',
      padding: '0 14px',
      font: 'var(--text-sm)'
    },
    md: {
      height: 'var(--control-md)',
      padding: '0 20px',
      font: 'var(--text-md)'
    },
    lg: {
      height: 'var(--control-lg)',
      padding: '0 26px',
      font: 'var(--text-lg)'
    },
    xl: {
      height: 'var(--control-xl)',
      padding: '0 32px',
      font: 'var(--text-lg)'
    }
  }[size];
  const variants = {
    primary: {
      background: 'var(--accent)',
      color: 'var(--text-on-accent)',
      border: '1px solid transparent'
    },
    secondary: {
      background: 'var(--surface-card-2)',
      color: 'var(--text-primary)',
      border: '1px solid var(--border-default)'
    },
    ghost: {
      background: 'transparent',
      color: 'var(--text-primary)',
      border: '1px solid transparent'
    },
    premium: {
      background: 'var(--premium)',
      color: '#FFFFFF',
      border: '1px solid transparent'
    },
    destructive: {
      background: 'var(--danger)',
      color: '#FFFFFF',
      border: '1px solid transparent'
    }
  }[variant];
  return /*#__PURE__*/React.createElement("button", _extends({
    disabled: disabled || loading,
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: 'var(--space-2)',
      width: fullWidth ? '100%' : 'auto',
      height: sizes.height,
      padding: sizes.padding,
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--fw-bold)',
      fontSize: sizes.font,
      lineHeight: 1,
      letterSpacing: 'var(--ls-tight)',
      borderRadius: 'var(--radius-pill)',
      cursor: disabled || loading ? 'not-allowed' : 'pointer',
      opacity: disabled ? 0.45 : 1,
      transition: 'transform var(--dur-micro) var(--ease-standard), background var(--dur-fast) var(--ease-standard), box-shadow var(--dur-fast) var(--ease-standard)',
      whiteSpace: 'nowrap',
      ...variants,
      ...style
    },
    onMouseDown: e => {
      if (!disabled && !loading) e.currentTarget.style.transform = 'scale(0.97)';
    },
    onMouseUp: e => {
      e.currentTarget.style.transform = 'scale(1)';
    },
    onMouseLeave: e => {
      e.currentTarget.style.transform = 'scale(1)';
    }
  }, rest), loading ? /*#__PURE__*/React.createElement("span", {
    style: {
      width: 16,
      height: 16,
      borderRadius: '50%',
      border: '2px solid currentColor',
      borderTopColor: 'transparent',
      animation: 'vb-spin 0.7s linear infinite',
      opacity: 0.9
    }
  }) : iconLeft, children, !loading && iconRight);
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Button.jsx", error: String((e && e.message) || e) }); }

// components/core/IconButton.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Square icon-only button (play/pause, settings, share, volume, bookmark…).
 * Always renders a 44px+ hit area. Pass a Lucide icon (or any node) as children.
 */
function IconButton({
  children,
  variant = 'ghost',
  size = 'md',
  active = false,
  disabled = false,
  label,
  style = {},
  ...rest
}) {
  const dim = {
    sm: 36,
    md: 44,
    lg: 52
  }[size];
  const variants = {
    solid: {
      background: 'var(--accent)',
      color: 'var(--text-on-accent)'
    },
    ghost: {
      background: 'transparent',
      color: 'var(--text-secondary)'
    },
    glass: {
      background: 'var(--glass-fill)',
      color: 'var(--text-primary)',
      backdropFilter: 'var(--blur-sm)'
    },
    card: {
      background: 'var(--surface-card-2)',
      color: 'var(--text-primary)',
      border: '1px solid var(--border-default)'
    }
  }[variant];
  return /*#__PURE__*/React.createElement("button", _extends({
    "aria-label": label,
    "aria-pressed": active,
    disabled: disabled,
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: dim,
      height: dim,
      flex: '0 0 auto',
      borderRadius: 'var(--radius-pill)',
      border: '1px solid transparent',
      cursor: disabled ? 'not-allowed' : 'pointer',
      opacity: disabled ? 0.4 : 1,
      color: active ? 'var(--accent)' : undefined,
      transition: 'background var(--dur-fast) var(--ease-standard), color var(--dur-fast) var(--ease-standard), transform var(--dur-micro) var(--ease-standard)',
      ...variants,
      ...(active ? {
        background: 'var(--accent-soft)',
        color: 'var(--accent)'
      } : {}),
      ...style
    },
    onMouseDown: e => {
      if (!disabled) e.currentTarget.style.transform = 'scale(0.92)';
    },
    onMouseUp: e => {
      e.currentTarget.style.transform = 'scale(1)';
    },
    onMouseLeave: e => {
      e.currentTarget.style.transform = 'scale(1)';
    }
  }, rest), children);
}
Object.assign(__ds_scope, { IconButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/IconButton.jsx", error: String((e && e.message) || e) }); }

// components/core/Input.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const {
  useState
} = React;
/**
 * Text input field. Supports password show/hide, leading icon, error state,
 * and a YouTube URL "paste" affordance. Theme-aware, 44px+ height.
 */
function Input({
  value,
  onChange,
  placeholder,
  type = 'text',
  label,
  hint,
  error,
  iconLeft = null,
  size = 'md',
  disabled = false,
  premiumLocked = false,
  style = {},
  ...rest
}) {
  const [show, setShow] = useState(false);
  const isPassword = type === 'password';
  const inputType = isPassword ? show ? 'text' : 'password' : type;
  const height = {
    md: 'var(--control-md)',
    lg: 'var(--control-lg)'
  }[size];
  return /*#__PURE__*/React.createElement("label", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 'var(--space-2)',
      ...style
    }
  }, label && /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-sm)',
      fontWeight: 'var(--fw-semibold)',
      color: 'var(--text-secondary)'
    }
  }, label), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-2)',
      height,
      padding: '0 14px',
      background: 'var(--surface-inset)',
      border: `1px solid ${error ? 'var(--danger)' : 'var(--border-default)'}`,
      borderRadius: 'var(--radius-md)',
      opacity: disabled ? 0.5 : 1,
      transition: 'border-color var(--dur-fast) var(--ease-standard), box-shadow var(--dur-fast) var(--ease-standard)'
    },
    onFocusCapture: e => {
      if (!error) {
        e.currentTarget.style.borderColor = 'var(--border-focus)';
        e.currentTarget.style.boxShadow = 'var(--ring-focus)';
      }
    },
    onBlurCapture: e => {
      e.currentTarget.style.boxShadow = 'none';
      if (!error) e.currentTarget.style.borderColor = 'var(--border-default)';
    }
  }, iconLeft && /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      color: 'var(--text-tertiary)'
    }
  }, iconLeft), /*#__PURE__*/React.createElement("input", _extends({
    value: value,
    onChange: onChange,
    placeholder: placeholder,
    type: inputType,
    disabled: disabled || premiumLocked,
    style: {
      flex: 1,
      minWidth: 0,
      height: '100%',
      border: 'none',
      outline: 'none',
      background: 'transparent',
      color: 'var(--text-primary)',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-md)'
    }
  }, rest)), premiumLocked && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-xs)',
      fontWeight: 'var(--fw-bold)',
      color: 'var(--premium)',
      letterSpacing: 'var(--ls-wider)'
    }
  }, "PREMIUM"), isPassword && !premiumLocked && /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: () => setShow(s => !s),
    style: {
      border: 'none',
      background: 'none',
      cursor: 'pointer',
      color: 'var(--text-tertiary)',
      fontSize: 'var(--text-sm)',
      fontWeight: 'var(--fw-semibold)',
      padding: 0
    }
  }, show ? 'Hide' : 'Show')), (hint || error) && /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-xs)',
      color: error ? 'var(--danger)' : 'var(--text-tertiary)'
    }
  }, error || hint));
}
Object.assign(__ds_scope, { Input });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Input.jsx", error: String((e && e.message) || e) }); }

// components/core/ProgressBar.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** Determinate progress bar. Used on video cards (in-progress), score reveal, XP-to-next-level. */
function ProgressBar({
  value = 0,
  max = 100,
  tone = 'accent',
  height = 8,
  showLabel = false,
  style = {},
  ...rest
}) {
  const pct = Math.max(0, Math.min(100, value / max * 100));
  const fill = {
    accent: 'var(--accent)',
    success: 'var(--success)',
    premium: 'var(--premium)',
    xp: 'linear-gradient(90deg, var(--teal-400), var(--teal-300))',
    streak: 'var(--streak)'
  }[tone] || 'var(--accent)';
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-3)',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height,
      background: 'var(--surface-inset)',
      borderRadius: 'var(--radius-pill)',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: `${pct}%`,
      height: '100%',
      background: fill,
      borderRadius: 'var(--radius-pill)',
      transition: 'width var(--dur-slow) var(--ease-out)'
    }
  })), showLabel && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-xs)',
      fontWeight: 'var(--fw-bold)',
      color: 'var(--text-secondary)',
      minWidth: 34,
      textAlign: 'right'
    }
  }, Math.round(pct), "%"));
}
Object.assign(__ds_scope, { ProgressBar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/ProgressBar.jsx", error: String((e && e.message) || e) }); }

// components/core/Skeleton.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** Shimmer skeleton placeholder. Use `variant="thumb"` for 16:9 video-card loading. */
function Skeleton({
  variant = 'line',
  width,
  height,
  style = {},
  ...rest
}) {
  const base = {
    background: 'linear-gradient(90deg, var(--surface-card) 25%, var(--surface-card-2) 50%, var(--surface-card) 75%)',
    backgroundSize: '200% 100%',
    animation: 'vb-shimmer 1.4s var(--ease-standard) infinite'
  };
  const variants = {
    line: {
      height: height || 12,
      width: width || '100%',
      borderRadius: 'var(--radius-xs)'
    },
    title: {
      height: height || 18,
      width: width || '70%',
      borderRadius: 'var(--radius-sm)'
    },
    thumb: {
      width: width || '100%',
      aspectRatio: '16 / 9',
      borderRadius: 'var(--radius-lg)'
    },
    circle: {
      width: width || 40,
      height: height || 40,
      borderRadius: '50%'
    },
    chip: {
      width: width || 64,
      height: height || 22,
      borderRadius: 'var(--radius-pill)'
    }
  }[variant];
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      ...base,
      ...variants,
      ...style
    }
  }, rest));
}
Object.assign(__ds_scope, { Skeleton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Skeleton.jsx", error: String((e && e.message) || e) }); }

// components/core/StarRating.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** 1–5 star rating display (Score Card). Read-only by default; supports half values. */
function StarRating({
  value = 0,
  max = 5,
  size = 24,
  gap = 4,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: 'inline-flex',
      gap,
      ...style
    },
    role: "img",
    "aria-label": `${value} of ${max} stars`
  }, rest), Array.from({
    length: max
  }).map((_, i) => {
    const fillPct = Math.max(0, Math.min(1, value - i)) * 100;
    return /*#__PURE__*/React.createElement("span", {
      key: i,
      style: {
        position: 'relative',
        width: size,
        height: size,
        display: 'inline-block',
        lineHeight: 1
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        position: 'absolute',
        inset: 0,
        color: 'var(--ink-600)',
        fontSize: size
      }
    }, "\u2605"), /*#__PURE__*/React.createElement("span", {
      style: {
        position: 'absolute',
        inset: 0,
        overflow: 'hidden',
        width: `${fillPct}%`,
        color: 'var(--gold)',
        fontSize: size,
        textShadow: fillPct > 0 ? 'var(--glow-gold)' : 'none'
      }
    }, "\u2605"));
  }));
}
Object.assign(__ds_scope, { StarRating });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/StarRating.jsx", error: String((e && e.message) || e) }); }

// components/core/Switch.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** Toggle switch (settings, theme, sound, translation). 44px+ touch row when labelled. */
function Switch({
  checked = false,
  onChange,
  disabled = false,
  label,
  tone = 'accent',
  style = {},
  ...rest
}) {
  const onColor = {
    accent: 'var(--accent)',
    premium: 'var(--premium)',
    success: 'var(--success)'
  }[tone];
  const knob = /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    role: "switch",
    "aria-checked": checked,
    "aria-label": label,
    disabled: disabled,
    onClick: () => onChange && onChange(!checked),
    style: {
      position: 'relative',
      width: 48,
      height: 28,
      flex: '0 0 auto',
      borderRadius: 'var(--radius-pill)',
      border: 'none',
      cursor: disabled ? 'not-allowed' : 'pointer',
      background: checked ? onColor : 'var(--ink-600)',
      opacity: disabled ? 0.5 : 1,
      transition: 'background var(--dur-fast) var(--ease-standard)',
      padding: 0,
      ...(!label ? style : {})
    }
  }, !label ? rest : {}), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 3,
      left: checked ? 23 : 3,
      width: 22,
      height: 22,
      borderRadius: '50%',
      background: '#fff',
      boxShadow: 'var(--shadow-sm)',
      transition: 'left var(--dur-fast) var(--ease-spring)'
    }
  }));
  if (!label) return knob;
  return /*#__PURE__*/React.createElement("label", _extends({
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 'var(--space-4)',
      minHeight: 'var(--touch-min)',
      cursor: 'pointer',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-md)',
      color: 'var(--text-primary)'
    }
  }, label), knob);
}
Object.assign(__ds_scope, { Switch });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Switch.jsx", error: String((e && e.message) || e) }); }

// components/core/Tag.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** Genre / category chip used on video cards and filter rows (Pop, Rap, News, Acoustic…). */
function Tag({
  children,
  icon = null,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 4,
      height: 22,
      padding: '0 9px',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-xs)',
      fontWeight: 'var(--fw-semibold)',
      color: 'var(--text-secondary)',
      background: 'var(--surface-card-2)',
      border: '1px solid var(--border-subtle)',
      borderRadius: 'var(--radius-pill)',
      whiteSpace: 'nowrap',
      ...style
    }
  }, rest), icon, children);
}
Object.assign(__ds_scope, { Tag });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Tag.jsx", error: String((e && e.message) || e) }); }

// components/core/Toast.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Toast notification — achievement, success, error, info.
 * Achievement toasts (badge unlocks) pop in with a glow. Render inside a fixed
 * top/bottom stack; this component is the visual cell.
 */
function Toast({
  tone = 'info',
  title,
  message,
  icon = null,
  onClose,
  style = {},
  ...rest
}) {
  const tones = {
    achievement: {
      accent: 'var(--premium)',
      glow: 'var(--glow-premium)',
      bg: 'var(--premium-soft)'
    },
    success: {
      accent: 'var(--success)',
      glow: 'var(--glow-success)',
      bg: 'var(--success-soft)'
    },
    error: {
      accent: 'var(--danger)',
      glow: 'none',
      bg: 'var(--danger-soft)'
    },
    info: {
      accent: 'var(--accent)',
      glow: 'none',
      bg: 'var(--accent-soft)'
    }
  }[tone];
  return /*#__PURE__*/React.createElement("div", _extends({
    role: "status",
    style: {
      display: 'flex',
      alignItems: 'flex-start',
      gap: 'var(--space-3)',
      width: 'min(360px, 92vw)',
      padding: 'var(--space-3) var(--space-4)',
      background: 'var(--surface-card)',
      border: `1px solid ${tones.accent}`,
      borderRadius: 'var(--radius-md)',
      boxShadow: tone === 'achievement' ? tones.glow : 'var(--shadow-lg)',
      animation: 'vb-pop-in var(--dur-spring) var(--ease-spring)',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      flex: '0 0 auto',
      width: 36,
      height: 36,
      borderRadius: 'var(--radius-pill)',
      background: tones.bg,
      color: tones.accent,
      fontSize: 18
    }
  }, icon || '✓'), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0,
      display: 'flex',
      flexDirection: 'column',
      gap: 2
    }
  }, title && /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--fw-bold)',
      fontSize: 'var(--text-md)',
      color: 'var(--text-primary)'
    }
  }, title), message && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--text-secondary)'
    }
  }, message)), onClose && /*#__PURE__*/React.createElement("button", {
    onClick: onClose,
    "aria-label": "Dismiss",
    style: {
      border: 'none',
      background: 'none',
      color: 'var(--text-tertiary)',
      cursor: 'pointer',
      fontSize: 18,
      lineHeight: 1,
      padding: 0
    }
  }, "\xD7"));
}
Object.assign(__ds_scope, { Toast });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Toast.jsx", error: String((e && e.message) || e) }); }

// components/media/CommunityReactions.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const REACTIONS = [{
  key: 'challenging',
  emoji: '💪',
  label: 'Challenging'
}, {
  key: 'enjoyable',
  emoji: '🎵',
  label: 'Enjoyable'
}, {
  key: 'vocab',
  emoji: '📚',
  label: 'Vocabulary-rich'
}];

/**
 * Community reactions — three emoji buttons with counts (Pre-play social proof).
 * `counts` = { challenging, enjoyable, vocab }; `active` = same shape of booleans.
 */
function CommunityReactions({
  counts = {},
  active = {},
  onReact,
  compact = false,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: 'flex',
      gap: 'var(--space-2)',
      flexWrap: 'wrap',
      ...style
    }
  }, rest), REACTIONS.map(r => {
    const on = active[r.key];
    return /*#__PURE__*/React.createElement("button", {
      key: r.key,
      onClick: () => onReact && onReact(r.key),
      "aria-pressed": on,
      style: {
        display: 'inline-flex',
        alignItems: 'center',
        gap: 6,
        height: 36,
        padding: compact ? '0 10px' : '0 12px',
        borderRadius: 'var(--radius-pill)',
        cursor: 'pointer',
        background: on ? 'var(--accent-soft)' : 'var(--surface-card-2)',
        border: `1px solid ${on ? 'var(--accent-border)' : 'var(--border-subtle)'}`,
        transition: 'background var(--dur-fast) var(--ease-standard), transform var(--dur-micro) var(--ease-spring)'
      },
      onMouseDown: e => {
        e.currentTarget.style.transform = 'scale(0.94)';
      },
      onMouseUp: e => {
        e.currentTarget.style.transform = 'scale(1)';
      },
      onMouseLeave: e => {
        e.currentTarget.style.transform = 'scale(1)';
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 16
      },
      "aria-hidden": "true"
    }, r.emoji), !compact && /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--text-sm)',
        color: 'var(--text-secondary)',
        fontWeight: 'var(--fw-medium)'
      }
    }, r.label), /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--text-sm)',
        fontWeight: 'var(--fw-bold)',
        color: on ? 'var(--accent)' : 'var(--text-primary)'
      }
    }, counts[r.key] ?? 0));
  }));
}
Object.assign(__ds_scope, { CommunityReactions });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/CommunityReactions.jsx", error: String((e && e.message) || e) }); }

// components/media/FilterChip.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** Selectable filter chip for scrollable filter rows (level, genre, duration, type). */
function FilterChip({
  children,
  selected = false,
  icon = null,
  onClick,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("button", _extends({
    onClick: onClick,
    "aria-pressed": selected,
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 6,
      height: 36,
      padding: '0 14px',
      flex: '0 0 auto',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-sm)',
      fontWeight: 'var(--fw-semibold)',
      borderRadius: 'var(--radius-pill)',
      cursor: 'pointer',
      whiteSpace: 'nowrap',
      color: selected ? 'var(--text-on-accent)' : 'var(--text-secondary)',
      background: selected ? 'var(--accent)' : 'var(--surface-card-2)',
      border: `1px solid ${selected ? 'transparent' : 'var(--border-subtle)'}`,
      transition: 'background var(--dur-fast) var(--ease-standard), color var(--dur-fast) var(--ease-standard)',
      ...style
    }
  }, rest), icon, children);
}
Object.assign(__ds_scope, { FilterChip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/FilterChip.jsx", error: String((e && e.message) || e) }); }

// components/media/LevelBadge.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const LEVELS = {
  A1: {
    var: '--cefr-a1',
    label: 'A1'
  },
  A2: {
    var: '--cefr-a2',
    label: 'A2'
  },
  B1: {
    var: '--cefr-b1',
    label: 'B1'
  },
  B2: {
    var: '--cefr-b2',
    label: 'B2'
  },
  C1: {
    var: '--cefr-c1',
    label: 'C1'
  }
};

/** CEFR level badge (A1–C1), color-coded. Sizes sm/md/lg. */
function LevelBadge({
  level = 'A1',
  size = 'md',
  soft = false,
  style = {},
  ...rest
}) {
  const meta = LEVELS[level] || LEVELS.A1;
  const color = `var(${meta.var})`;
  const sizes = {
    sm: {
      h: 18,
      font: 'var(--text-2xs)',
      pad: '0 6px'
    },
    md: {
      h: 22,
      font: 'var(--text-xs)',
      pad: '0 8px'
    },
    lg: {
      h: 28,
      font: 'var(--text-sm)',
      pad: '0 11px'
    }
  }[size];
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      height: sizes.h,
      padding: sizes.pad,
      fontFamily: 'var(--font-display)',
      fontSize: sizes.font,
      fontWeight: 'var(--fw-extrabold)',
      letterSpacing: 'var(--ls-wide)',
      borderRadius: 'var(--radius-sm)',
      color: soft ? color : '#0A0A12',
      background: soft ? 'color-mix(in srgb, ' + 'transparent' + ', transparent)' : color,
      backgroundColor: soft ? `color-mix(in srgb, var(${meta.var}) 18%, transparent)` : color,
      border: soft ? `1px solid color-mix(in srgb, var(${meta.var}) 40%, transparent)` : 'none',
      ...style
    },
    "aria-label": `Level ${meta.label}`
  }, rest), meta.label);
}
Object.assign(__ds_scope, { LevelBadge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/LevelBadge.jsx", error: String((e && e.message) || e) }); }

// components/media/StatCard.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/** Stat card — icon + number + label. Used on Progress dashboard (streak, XP, exercises, accuracy). */
function StatCard({
  icon,
  value,
  label,
  tone = 'accent',
  style = {},
  ...rest
}) {
  const color = {
    accent: 'var(--accent)',
    streak: 'var(--streak)',
    xp: 'var(--xp)',
    success: 'var(--success)',
    premium: 'var(--premium)',
    neutral: 'var(--text-primary)'
  }[tone];
  const soft = {
    accent: 'var(--accent-soft)',
    streak: 'var(--warning-soft)',
    xp: 'var(--accent-soft)',
    success: 'var(--success-soft)',
    premium: 'var(--premium-soft)',
    neutral: 'var(--surface-card-2)'
  }[tone];
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 'var(--space-2)',
      padding: 'var(--space-4)',
      background: 'var(--surface-card)',
      border: '1px solid var(--border-subtle)',
      borderRadius: 'var(--radius-lg)',
      ...style
    }
  }, rest), icon && /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: 36,
      height: 36,
      borderRadius: 'var(--radius-pill)',
      background: soft,
      color,
      fontSize: 18
    }
  }, icon), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--fw-black)',
      fontSize: 'var(--text-2xl)',
      color: 'var(--text-primary)',
      lineHeight: 1,
      letterSpacing: 'var(--ls-tight)'
    }
  }, value), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--text-tertiary)'
    }
  }, label));
}
Object.assign(__ds_scope, { StatCard });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/StatCard.jsx", error: String((e && e.message) || e) }); }

// components/media/VersionSelector.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Exercise version selector — tab-style row with lock states.
 * Each version: { id, label, strategy, locked }. v1 is always available.
 */
function VersionSelector({
  versions = [],
  value,
  onChange,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: 'flex',
      gap: 'var(--space-2)',
      overflowX: 'auto',
      paddingBottom: 2,
      ...style
    }
  }, rest), versions.map(v => {
    const selected = v.id === value;
    const locked = v.locked;
    return /*#__PURE__*/React.createElement("button", {
      key: v.id,
      disabled: locked,
      onClick: () => !locked && onChange && onChange(v.id),
      title: locked ? 'Complete version 1 or go Premium to unlock' : undefined,
      style: {
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'flex-start',
        gap: 2,
        minWidth: 96,
        padding: '8px 12px',
        flex: '0 0 auto',
        textAlign: 'left',
        cursor: locked ? 'not-allowed' : 'pointer',
        background: selected ? 'var(--accent-soft)' : 'var(--surface-card-2)',
        border: `1px solid ${selected ? 'var(--accent-border)' : 'var(--border-subtle)'}`,
        borderRadius: 'var(--radius-md)',
        opacity: locked ? 0.55 : 1,
        transition: 'background var(--dur-fast) var(--ease-standard), border-color var(--dur-fast) var(--ease-standard)'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'flex',
        alignItems: 'center',
        gap: 5
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontFamily: 'var(--font-display)',
        fontWeight: 'var(--fw-bold)',
        fontSize: 'var(--text-sm)',
        color: selected ? 'var(--accent)' : 'var(--text-primary)'
      }
    }, v.label), locked && /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 12,
        color: 'var(--text-tertiary)'
      },
      "aria-label": "Locked"
    }, "\uD83D\uDD12")), /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--text-2xs)',
        color: 'var(--text-tertiary)',
        textTransform: 'uppercase',
        letterSpacing: 'var(--ls-wide)'
      }
    }, v.strategy));
  }));
}
Object.assign(__ds_scope, { VersionSelector });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/VersionSelector.jsx", error: String((e && e.message) || e) }); }

// components/media/VideoCard.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const {
  useState
} = React;
/**
 * VideoCard — the fundamental library component. 16:9 thumbnail, metadata,
 * level badge, genre tag, completion/in-progress state. Desktop hover lifts.
 * Pass `thumb` (image URL) or `thumbColor` (gradient fallback).
 */
function VideoCard({
  title = 'Untitled',
  artist = '',
  level = 'A1',
  genre = '',
  duration = '',
  practiced = '',
  thumb = '',
  thumbColor = 'linear-gradient(135deg, #2C2C44, #1A1A2E)',
  isNew = false,
  state = 'none',
  // 'none' | 'completed' | 'in-progress'
  progress = 0,
  onClick,
  style = {},
  ...rest
}) {
  const [hover, setHover] = useState(false);
  return /*#__PURE__*/React.createElement("div", _extends({
    onClick: onClick,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => setHover(false),
    style: {
      display: 'flex',
      flexDirection: 'column',
      cursor: 'pointer',
      background: 'var(--surface-card)',
      border: '1px solid var(--border-subtle)',
      borderRadius: 'var(--radius-lg)',
      overflow: 'hidden',
      transform: hover ? 'translateY(-2px)' : 'translateY(0)',
      boxShadow: hover ? 'var(--shadow-lg)' : 'var(--shadow-sm)',
      transition: 'transform var(--dur-fast) var(--ease-standard), box-shadow var(--dur-fast) var(--ease-standard)',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      width: '100%',
      aspectRatio: '16 / 9',
      background: thumbColor
    }
  }, thumb && /*#__PURE__*/React.createElement("img", {
    src: thumb,
    alt: title,
    style: {
      position: 'absolute',
      inset: 0,
      width: '100%',
      height: '100%',
      objectFit: 'cover'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 8,
      left: 8,
      display: 'flex',
      gap: 6
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.LevelBadge, {
    level: level,
    size: "sm"
  }), isNew && /*#__PURE__*/React.createElement(__ds_scope.Badge, {
    tone: "new",
    size: "sm"
  }, "New")), duration && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      bottom: 8,
      right: 8,
      padding: '2px 7px',
      borderRadius: 'var(--radius-xs)',
      background: 'rgba(7,7,16,0.78)',
      color: '#fff',
      fontSize: 'var(--text-2xs)',
      fontWeight: 'var(--fw-bold)',
      fontFamily: 'var(--font-body)'
    }
  }, duration), state === 'completed' && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 8,
      right: 8,
      width: 26,
      height: 26,
      borderRadius: '50%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'var(--success)',
      color: '#04140C',
      fontSize: 15,
      fontWeight: 800,
      boxShadow: 'var(--glow-success)'
    },
    "aria-label": "Completed"
  }, "\u2713"), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      opacity: hover ? 1 : 0,
      transition: 'opacity var(--dur-fast) var(--ease-standard)',
      background: hover ? 'rgba(7,7,16,0.30)' : 'transparent'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 48,
      height: 48,
      borderRadius: '50%',
      background: 'var(--accent)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: 'var(--text-on-accent)',
      boxShadow: 'var(--glow-accent)'
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "20",
    height: "20",
    viewBox: "0 0 24 24",
    fill: "currentColor"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M8 5.14v13.72L19 12 8 5.14z"
  })))), state === 'in-progress' && /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      bottom: 0
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ProgressBar, {
    value: progress,
    height: 4,
    style: {
      padding: 0
    }
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 6,
      padding: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--fw-bold)',
      fontSize: 'var(--text-md)',
      color: 'var(--text-primary)',
      lineHeight: 'var(--lh-snug)',
      display: '-webkit-box',
      WebkitLineClamp: 2,
      WebkitBoxOrient: 'vertical',
      overflow: 'hidden'
    }
  }, title), artist && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--text-tertiary)'
    }
  }, artist), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      marginTop: 2,
      flexWrap: 'wrap'
    }
  }, genre && /*#__PURE__*/React.createElement(__ds_scope.Tag, null, genre), practiced && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--text-tertiary)',
      marginLeft: 'auto'
    }
  }, practiced, " practiced"))));
}
Object.assign(__ds_scope, { VideoCard });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/media/VideoCard.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/AppData.js
try { (() => {
// Sample content for the Vocabik app UI kit. Attached to window for cross-file use.
window.VBK = window.VBK || {};
window.VBK.videos = [{
  id: 1,
  title: 'As It Was',
  artist: 'Harry Styles',
  level: 'B1',
  genre: 'Pop',
  duration: '2:47',
  practiced: '1.2k',
  thumb: 'linear-gradient(135deg,#FF6FB5,#FFA84D)',
  state: 'none'
}, {
  id: 2,
  title: 'Lose Yourself',
  artist: 'Eminem',
  level: 'C1',
  genre: 'Rap',
  duration: '5:26',
  practiced: '892',
  thumb: 'linear-gradient(135deg,#0E3B3A,#00C9B3)',
  state: 'in-progress',
  progress: 45
}, {
  id: 3,
  title: 'BBC 6-Minute English',
  artist: 'BBC Learning',
  level: 'B2',
  genre: 'News',
  duration: '6:10',
  practiced: '3.4k',
  thumb: 'linear-gradient(135deg,#16234A,#2C4A8A)',
  state: 'completed'
}, {
  id: 4,
  title: 'Perfect',
  artist: 'Ed Sheeran',
  level: 'A2',
  genre: 'Acoustic',
  duration: '4:23',
  practiced: '5.1k',
  thumb: 'linear-gradient(135deg,#6D3BFF,#B06BFF)',
  state: 'none'
}, {
  id: 5,
  title: 'Counting Stars',
  artist: 'OneRepublic',
  level: 'B1',
  genre: 'Pop',
  duration: '4:17',
  practiced: '2.8k',
  thumb: 'linear-gradient(135deg,#FF8A5B,#FFC93C)',
  state: 'none',
  isNew: true
}, {
  id: 6,
  title: 'Believer',
  artist: 'Imagine Dragons',
  level: 'B2',
  genre: 'Rock',
  duration: '3:24',
  practiced: '4.0k',
  thumb: 'linear-gradient(135deg,#C1121F,#5A0E12)',
  state: 'none'
}];
window.VBK.daily = {
  title: 'Watermelon Sugar',
  artist: 'Harry Styles',
  level: 'B1',
  genre: 'Pop',
  duration: '3:09',
  practiced: '8.6k',
  thumb: 'linear-gradient(135deg,#FF6FB5,#FF9D4D)',
  blanks: 12
};

// One exercise's blanks (active player demo)
window.VBK.exercise = {
  title: 'As It Was',
  artist: 'Harry Styles',
  level: 'B1',
  genre: 'Pop',
  thumb: 'linear-gradient(135deg,#FF6FB5,#FFA84D)',
  blanks: [{
    before: 'Holdin\u2019 me back',
    answer: 'gravity',
    after: ', holdin\u2019 me back',
    options: ['gravity', 'honestly', 'company', 'memory'],
    ipa: '/\u02c8\u0261r\u00e6v.\u0259.ti/',
    vi: 'L\u1ef1c h\u1ea5p d\u1eabn k\u00e9o t\u00f4i l\u1ea1i'
  }, {
    before: 'In this',
    answer: 'world',
    after: ', it\u2019s just us',
    options: ['word', 'world', 'work', 'wall'],
    ipa: '/w\u025c\u02d0ld/',
    vi: 'Trong th\u1ebf gi\u1edbi n\u00e0y'
  }]
};
window.VBK.user = {
  name: 'Mai Linh',
  streak: 5,
  xp: 1240,
  done: 2,
  cap: 5,
  level: 'Explorer',
  premium: false
};
window.VBK.versions = [{
  id: 'v1',
  label: 'Version 1',
  strategy: 'Vocabulary'
}, {
  id: 'v2',
  label: 'Version 2',
  strategy: 'Grammar',
  locked: true
}, {
  id: 'v3',
  label: 'Version 3',
  strategy: 'Speed',
  locked: true
}];
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/AppData.js", error: String((e && e.message) || e) }); }

// ui_kits/app/ExerciseScreen.jsx
try { (() => {
// ExerciseScreen — pre-play + active bottom-sheet exercise player.
const {
  VersionSelector,
  CommunityReactions,
  Button,
  LevelBadge,
  Tag,
  IconButton,
  Badge,
  ProgressBar
} = window.VocabikDesignSystem_0b21db;
function ExerciseScreen({
  onComplete,
  onBack
}) {
  const ex = window.VBK.exercise;
  const [phase, setPhase] = React.useState('preplay'); // preplay | active
  const [ver, setVer] = React.useState('v1');
  const [reactions, setReactions] = React.useState({
    enjoyable: true
  });
  const [idx, setIdx] = React.useState(0);
  const [picked, setPicked] = React.useState(null);
  const [showVi, setShowVi] = React.useState(false);
  const [results, setResults] = React.useState([]);
  const blank = ex.blanks[idx];
  function pick(opt) {
    if (picked) return;
    setPicked(opt);
    const correct = opt === blank.answer;
    setTimeout(() => {
      const next = [...results, correct];
      setResults(next);
      if (idx + 1 >= ex.blanks.length) {
        onComplete(next);
      } else {
        setIdx(idx + 1);
        setPicked(null);
        setShowVi(false);
      }
    }, 1100);
  }
  if (phase === 'preplay') {
    return /*#__PURE__*/React.createElement("div", {
      style: {
        display: 'flex',
        flexDirection: 'column',
        gap: 18,
        padding: '0 16px 24px'
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        position: 'relative',
        borderRadius: 'var(--radius-xl)',
        overflow: 'hidden',
        boxShadow: 'var(--shadow-lg)'
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        width: '100%',
        aspectRatio: '16/9',
        background: ex.thumb
      }
    }), /*#__PURE__*/React.createElement("div", {
      style: {
        position: 'absolute',
        inset: 0,
        background: 'var(--scrim-bottom)'
      }
    }), /*#__PURE__*/React.createElement("button", {
      onClick: () => setPhase('active'),
      style: {
        position: 'absolute',
        inset: 0,
        margin: 'auto',
        width: 64,
        height: 64,
        borderRadius: '50%',
        border: 'none',
        background: 'var(--accent)',
        color: 'var(--text-on-accent)',
        cursor: 'pointer',
        boxShadow: 'var(--glow-accent)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center'
      }
    }, /*#__PURE__*/React.createElement("svg", {
      width: "26",
      height: "26",
      viewBox: "0 0 24 24",
      fill: "currentColor"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M8 5.14v13.72L19 12 8 5.14z"
    }))), /*#__PURE__*/React.createElement("div", {
      style: {
        position: 'absolute',
        left: 14,
        right: 14,
        bottom: 12
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        display: 'flex',
        gap: 6,
        marginBottom: 6
      }
    }, /*#__PURE__*/React.createElement(LevelBadge, {
      level: ex.level
    }), /*#__PURE__*/React.createElement(Tag, null, ex.genre)), /*#__PURE__*/React.createElement("div", {
      style: {
        fontFamily: 'var(--font-display)',
        fontWeight: 900,
        fontSize: 22,
        color: '#fff'
      }
    }, ex.title), /*#__PURE__*/React.createElement("div", {
      style: {
        fontSize: 13,
        color: 'rgba(255,255,255,0.8)'
      }
    }, ex.artist))), /*#__PURE__*/React.createElement("div", {
      style: {
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        flexWrap: 'wrap'
      }
    }, /*#__PURE__*/React.createElement(Badge, {
      tone: "accent"
    }, "Multiple choice"), /*#__PURE__*/React.createElement(Badge, {
      tone: "neutral"
    }, ex.blanks.length, " blanks"), /*#__PURE__*/React.createElement(Badge, {
      tone: "success",
      soft: true
    }, "Prev. score 82%")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
      style: {
        fontFamily: 'var(--font-display)',
        fontWeight: 800,
        fontSize: 14,
        marginBottom: 8,
        color: 'var(--text-secondary)'
      }
    }, "Choose a version"), /*#__PURE__*/React.createElement(VersionSelector, {
      versions: window.VBK.versions,
      value: ver,
      onChange: setVer
    })), /*#__PURE__*/React.createElement(CommunityReactions, {
      counts: {
        challenging: 128,
        enjoyable: 342,
        vocab: 96
      },
      active: reactions,
      onReact: k => setReactions(r => ({
        ...r,
        [k]: !r[k]
      }))
    }), /*#__PURE__*/React.createElement(Button, {
      variant: "primary",
      size: "xl",
      fullWidth: true,
      onClick: () => setPhase('active')
    }, "Start exercise"));
  }

  // ACTIVE
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      height: '100%',
      display: 'flex',
      flexDirection: 'column'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      height: '46%',
      background: ex.thumb,
      flex: '0 0 auto'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'rgba(7,7,16,0.30)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 12,
      left: 12,
      right: 12,
      display: 'flex',
      justifyContent: 'space-between'
    }
  }, /*#__PURE__*/React.createElement(IconButton, {
    variant: "glass",
    size: "sm",
    label: "Back",
    onClick: onBack
  }, /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    "stroke-width": "2.4",
    "stroke-linecap": "round"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M15 18l-6-6 6-6"
  }))), /*#__PURE__*/React.createElement(IconButton, {
    variant: "glass",
    size: "sm",
    label: "Sound"
  }, /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    "stroke-width": "2.2",
    "stroke-linecap": "round",
    "stroke-linejoin": "round"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M11 5L6 9H2v6h4l5 4V5z"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M19.07 4.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07"
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 14,
      right: 14,
      bottom: 12
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      height: 4,
      borderRadius: 2,
      background: 'rgba(255,255,255,0.25)',
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      top: 0,
      height: '100%',
      width: `${idx / ex.blanks.length * 100 + 20}%`,
      background: 'var(--accent)',
      borderRadius: 2
    }
  }), ex.blanks.map((_, i) => {
    const r = results[i];
    const color = r === true ? 'var(--success)' : r === false ? 'var(--danger)' : i === idx ? '#fff' : 'rgba(0,229,204,0.5)';
    return /*#__PURE__*/React.createElement("span", {
      key: i,
      style: {
        position: 'absolute',
        top: -3,
        left: `${20 + i * 30}%`,
        width: 10,
        height: 10,
        borderRadius: '50%',
        background: color,
        animation: i === idx ? 'vb-pulse-dot 1.2s infinite' : 'none'
      }
    });
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      background: 'var(--surface-raised)',
      borderTopLeftRadius: 'var(--radius-xl)',
      borderTopRightRadius: 'var(--radius-xl)',
      marginTop: -20,
      position: 'relative',
      boxShadow: 'var(--shadow-xl)',
      padding: '14px 18px 20px',
      display: 'flex',
      flexDirection: 'column',
      gap: 16,
      animation: 'vb-sheet-up var(--dur-spring) var(--ease-spring)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 40,
      height: 4,
      borderRadius: 2,
      background: 'var(--border-strong)',
      margin: '0 auto'
    }
  }), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      marginBottom: 10
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 12,
      color: 'var(--text-tertiary)'
    }
  }, "Blank ", idx + 1, " of ", ex.blanks.length), /*#__PURE__*/React.createElement("button", {
    onClick: () => setShowVi(v => !v),
    style: {
      border: 'none',
      background: 'none',
      color: 'var(--accent)',
      fontSize: 13,
      fontWeight: 600,
      cursor: 'pointer'
    }
  }, showVi ? 'Hide' : 'Show', " translation")), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-body)',
      fontSize: 18,
      lineHeight: 1.6,
      color: 'var(--text-primary)'
    }
  }, blank.before, ' ', /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-block',
      minWidth: 70,
      borderBottom: `2px solid ${picked ? picked === blank.answer ? 'var(--success)' : 'var(--danger)' : 'var(--accent)'}`,
      textAlign: 'center',
      fontWeight: 700,
      color: picked ? picked === blank.answer ? 'var(--success)' : 'var(--danger)' : 'transparent'
    }
  }, picked ? blank.answer : '\u00a0'), blank.after), showVi && /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 6,
      fontSize: 14,
      color: 'var(--text-tertiary)',
      fontStyle: 'italic'
    }
  }, blank.vi)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: 10
    }
  }, blank.options.map(opt => {
    const isPicked = picked === opt;
    const isAnswer = opt === blank.answer;
    let bg = 'var(--surface-card-2)',
      border = 'var(--border-default)',
      color = 'var(--text-primary)',
      anim = 'none';
    if (picked) {
      if (isAnswer) {
        bg = 'var(--success-soft)';
        border = 'var(--success)';
        color = 'var(--success)';
      } else if (isPicked) {
        bg = 'var(--danger-soft)';
        border = 'var(--danger)';
        color = 'var(--danger)';
        anim = 'vb-shake 0.4s';
      }
    }
    return /*#__PURE__*/React.createElement("button", {
      key: opt,
      onClick: () => pick(opt),
      disabled: !!picked,
      style: {
        minHeight: 52,
        borderRadius: 'var(--radius-pill)',
        border: `1.5px solid ${border}`,
        background: bg,
        color,
        fontFamily: 'var(--font-body)',
        fontSize: 16,
        fontWeight: 600,
        cursor: picked ? 'default' : 'pointer',
        animation: anim,
        transition: 'all var(--dur-fast) var(--ease-standard)'
      }
    }, opt);
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement("button", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 6,
      border: 'none',
      background: 'none',
      color: 'var(--text-tertiary)',
      fontSize: 13,
      cursor: 'pointer'
    }
  }, /*#__PURE__*/React.createElement("span", null, "\uD83D\uDCA1"), " Hint ", /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--warning)',
      fontWeight: 700
    }
  }, "(\u221250% XP)")))));
}
window.ExerciseScreen = ExerciseScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/ExerciseScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/HomeScreen.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
// HomeScreen — library home for a Free user. Composes DS components.
const {
  VideoCard,
  LevelBadge,
  Badge,
  Button,
  FilterChip,
  Tag,
  ProgressBar
} = window.VocabikDesignSystem_0b21db;
function HomeScreen({
  onOpenExercise
}) {
  const [filter, setFilter] = React.useState('All');
  const d = window.VBK.daily;
  const videos = window.VBK.videos;
  const levels = ['All', 'A1', 'A2', 'B1', 'B2', 'C1'];
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 22,
      paddingBottom: 24
    }
  }, /*#__PURE__*/React.createElement("section", {
    style: {
      padding: '0 16px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      marginBottom: 10
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 13,
      letterSpacing: '0.06em',
      textTransform: 'uppercase',
      color: 'var(--accent)'
    }
  }, "Daily pick"), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 12,
      color: 'var(--text-tertiary)'
    }
  }, "Resets in 6h")), /*#__PURE__*/React.createElement("div", {
    onClick: onOpenExercise,
    style: {
      position: 'relative',
      borderRadius: 'var(--radius-xl)',
      overflow: 'hidden',
      cursor: 'pointer',
      boxShadow: 'var(--shadow-lg)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      aspectRatio: '16/9',
      background: d.thumb
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--scrim-bottom)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 12,
      left: 12,
      display: 'flex',
      gap: 6
    }
  }, /*#__PURE__*/React.createElement(LevelBadge, {
    level: d.level,
    size: "md"
  }), /*#__PURE__*/React.createElement(Tag, null, d.genre)), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 12,
      right: 12,
      width: 44,
      height: 44,
      borderRadius: '50%',
      background: 'var(--accent)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: 'var(--text-on-accent)',
      boxShadow: 'var(--glow-accent)'
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "currentColor"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M8 5.14v13.72L19 12 8 5.14z"
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 14,
      right: 14,
      bottom: 12
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 22,
      color: '#fff',
      lineHeight: 1.1
    }
  }, d.title), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 13,
      color: 'rgba(255,255,255,0.8)',
      marginTop: 2
    }
  }, d.artist, " \xB7 ", d.blanks, " blanks \xB7 ", d.practiced, " practiced")))), /*#__PURE__*/React.createElement("section", null, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      overflowX: 'auto',
      padding: '0 16px',
      scrollbarWidth: 'none'
    }
  }, levels.map(l => /*#__PURE__*/React.createElement(FilterChip, {
    key: l,
    selected: filter === l,
    onClick: () => setFilter(l)
  }, l)))), /*#__PURE__*/React.createElement(Row, {
    title: "Trending this week",
    videos: videos.slice(0, 4),
    onOpen: onOpenExercise
  }), /*#__PURE__*/React.createElement(Row, {
    title: "New additions",
    videos: [videos[4], videos[5], videos[3]],
    onOpen: onOpenExercise
  }), /*#__PURE__*/React.createElement("section", {
    style: {
      padding: '0 16px'
    }
  }, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 18,
      marginBottom: 12
    }
  }, "Your library"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: 12
    }
  }, videos.map(v => /*#__PURE__*/React.createElement(VideoCard, _extends({
    key: v.id
  }, v, {
    thumbColor: v.thumb,
    onClick: onOpenExercise
  }))))));
}
function Row({
  title,
  videos,
  onOpen
}) {
  return /*#__PURE__*/React.createElement("section", null, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 18,
      margin: '0 16px 12px'
    }
  }, title), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 12,
      overflowX: 'auto',
      padding: '0 16px 4px',
      scrollbarWidth: 'none'
    }
  }, videos.map(v => /*#__PURE__*/React.createElement("div", {
    key: v.id,
    style: {
      width: 220,
      flex: '0 0 auto'
    }
  }, /*#__PURE__*/React.createElement(VideoCard, _extends({}, v, {
    thumbColor: v.thumb,
    onClick: onOpen
  }))))));
}
window.HomeScreen = HomeScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/HomeScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/ProgressScreen.jsx
try { (() => {
// ProgressScreen — dashboard: stats, streak heatmap, weekly XP, level title.
const {
  StatCard,
  ProgressBar,
  Avatar,
  Badge
} = window.VocabikDesignSystem_0b21db;
function ProgressScreen() {
  const u = window.VBK.user;
  // 30-day heatmap intensities (0–3)
  const days = [1, 2, 0, 3, 2, 1, 3, 3, 2, 0, 1, 2, 3, 1, 0, 2, 3, 3, 1, 2, 0, 1, 3, 2, 3, 1, 2, 0, 3, 2];
  const heat = ['var(--surface-card-2)', 'rgba(0,229,204,0.25)', 'rgba(0,229,204,0.55)', 'var(--accent)'];
  const weeks = [12, 28, 18, 34, 22, 40, 24];
  const maxW = Math.max(...weeks);
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 20,
      padding: '0 16px 24px'
    }
  }, /*#__PURE__*/React.createElement("h2", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 24,
      marginTop: 4
    }
  }, "Your progress"), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: 16,
      borderRadius: 'var(--radius-lg)',
      background: 'var(--surface-card)',
      border: '1px solid var(--border-subtle)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      marginBottom: 10
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 22
    }
  }, "\uD83C\uDFC5"), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 17
    }
  }, u.level), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 12,
      color: 'var(--text-tertiary)'
    }
  }, "460 XP to Fluent Challenger"))), /*#__PURE__*/React.createElement(Badge, {
    tone: "accent"
  }, "Level 2")), /*#__PURE__*/React.createElement(ProgressBar, {
    value: 64,
    tone: "xp"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: 12
    }
  }, /*#__PURE__*/React.createElement(StatCard, {
    icon: "\uD83D\uDD25",
    value: u.streak,
    label: "Day streak",
    tone: "streak"
  }), /*#__PURE__*/React.createElement(StatCard, {
    icon: "\u26A1",
    value: u.xp.toLocaleString(),
    label: "Total XP",
    tone: "xp"
  }), /*#__PURE__*/React.createElement(StatCard, {
    icon: "\uD83C\uDFAF",
    value: "87%",
    label: "Avg accuracy",
    tone: "success"
  }), /*#__PURE__*/React.createElement(StatCard, {
    icon: "\uD83D\uDCDA",
    value: "34",
    label: "Exercises",
    tone: "accent"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: 16,
      borderRadius: 'var(--radius-lg)',
      background: 'var(--surface-card)',
      border: '1px solid var(--border-subtle)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 15,
      marginBottom: 12
    }
  }, "Last 30 days"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(10, 1fr)',
      gap: 6
    }
  }, days.map((d, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      aspectRatio: '1',
      borderRadius: 5,
      background: heat[d]
    }
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: 16,
      borderRadius: 'var(--radius-lg)',
      background: 'var(--surface-card)',
      border: '1px solid var(--border-subtle)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 15,
      marginBottom: 14
    }
  }, "XP this week"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'flex-end',
      justifyContent: 'space-between',
      gap: 8,
      height: 100
    }
  }, weeks.map((w, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      flex: 1,
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      gap: 6
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      height: `${w / maxW * 100}%`,
      minHeight: 6,
      background: i === 5 ? 'var(--accent)' : 'var(--accent-soft)',
      borderRadius: 6
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 10,
      color: 'var(--text-tertiary)'
    }
  }, 'SMTWTFS'[i]))))));
}
window.ProgressScreen = ProgressScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/ProgressScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/app/ScoreScreen.jsx
try { (() => {
// ScoreScreen — post-exercise result + shareable Score Card.
const {
  StarRating,
  Button,
  Badge,
  StatCard,
  LevelBadge
} = window.VocabikDesignSystem_0b21db;
function ScoreScreen({
  results = [true, false],
  onLibrary,
  onRetry
}) {
  const correct = results.filter(Boolean).length;
  const total = results.length || 1;
  const pct = Math.round(correct / total * 100);
  const stars = Math.max(1, Math.round(pct / 20));
  const ex = window.VBK.exercise;
  const [count, setCount] = React.useState(0);
  React.useEffect(() => {
    let raf;
    const start = performance.now();
    const dur = 900;
    const tick = t => {
      const p = Math.min(1, (t - start) / dur);
      setCount(Math.round((1 - Math.pow(1 - p, 3)) * pct));
      if (p < 1) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [pct]);
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 18,
      padding: '8px 16px 24px',
      alignItems: 'center',
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 24,
      marginTop: 6
    }
  }, "Nice work!"), /*#__PURE__*/React.createElement(StarRating, {
    value: stars,
    size: 34
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 64,
      lineHeight: 1,
      color: 'var(--accent)',
      textShadow: 'var(--glow-accent)'
    }
  }, count, "%"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 13,
      color: 'var(--text-tertiary)',
      marginTop: -8
    }
  }, "accuracy"), /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      borderRadius: 'var(--radius-xl)',
      overflow: 'hidden',
      background: 'var(--grad-pop)',
      padding: 18,
      textAlign: 'left',
      position: 'relative',
      boxShadow: 'var(--shadow-lg)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 16,
      color: '#fff'
    }
  }, "Vocab", /*#__PURE__*/React.createElement("span", {
    style: {
      opacity: 0.85
    }
  }, "ik")), /*#__PURE__*/React.createElement(LevelBadge, {
    level: ex.level
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 26,
      color: '#fff',
      marginTop: 28
    }
  }, pct, "% accuracy"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 14,
      color: 'rgba(255,255,255,0.9)'
    }
  }, ex.title, " \xB7 ", ex.artist)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr 1fr',
      gap: 10,
      width: '100%'
    }
  }, /*#__PURE__*/React.createElement(StatCard, {
    value: correct,
    label: "Correct",
    tone: "success"
  }), /*#__PURE__*/React.createElement(StatCard, {
    value: total - correct,
    label: "Missed",
    tone: "neutral"
  }), /*#__PURE__*/React.createElement(StatCard, {
    value: "1:24",
    label: "Time",
    tone: "accent"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      display: 'flex',
      gap: 10
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      padding: 14,
      borderRadius: 'var(--radius-lg)',
      background: 'var(--accent-soft)',
      border: '1px solid var(--accent-border)',
      display: 'flex',
      alignItems: 'center',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 20
    }
  }, "\u26A1"), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 18,
      color: 'var(--accent)'
    }
  }, "+24 XP"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 11,
      color: 'var(--text-tertiary)'
    }
  }, "earned"))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      padding: 14,
      borderRadius: 'var(--radius-lg)',
      background: 'var(--warning-soft)',
      border: '1px solid rgba(255,178,62,0.3)',
      display: 'flex',
      alignItems: 'center',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 20
    }
  }, "\uD83D\uDD25"), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 900,
      fontSize: 18,
      color: 'var(--streak)'
    }
  }, "6 days"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 11,
      color: 'var(--text-tertiary)'
    }
  }, "streak +1")))), /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      display: 'flex',
      flexDirection: 'column',
      gap: 10,
      marginTop: 4
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "premium",
    size: "lg",
    fullWidth: true
  }, "Try version 2: Grammar focus"), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    size: "lg",
    fullWidth: true,
    onClick: onRetry
  }, "Next suggested exercise"), /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "md",
    fullWidth: true,
    onClick: onLibrary
  }, "Back to library")));
}
window.ScoreScreen = ScoreScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/app/ScoreScreen.jsx", error: String((e && e.message) || e) }); }

__ds_ns.Avatar = __ds_scope.Avatar;

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.Button = __ds_scope.Button;

__ds_ns.IconButton = __ds_scope.IconButton;

__ds_ns.Input = __ds_scope.Input;

__ds_ns.ProgressBar = __ds_scope.ProgressBar;

__ds_ns.Skeleton = __ds_scope.Skeleton;

__ds_ns.StarRating = __ds_scope.StarRating;

__ds_ns.Switch = __ds_scope.Switch;

__ds_ns.Tag = __ds_scope.Tag;

__ds_ns.Toast = __ds_scope.Toast;

__ds_ns.CommunityReactions = __ds_scope.CommunityReactions;

__ds_ns.FilterChip = __ds_scope.FilterChip;

__ds_ns.LevelBadge = __ds_scope.LevelBadge;

__ds_ns.StatCard = __ds_scope.StatCard;

__ds_ns.VersionSelector = __ds_scope.VersionSelector;

__ds_ns.VideoCard = __ds_scope.VideoCard;

})();
