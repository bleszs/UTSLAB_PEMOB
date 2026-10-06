# Source and design observations

Fresh full finish review, 7 October 2026. Write scope: this file and finish-review.md only; no source changes were made.

Reviewed PRODUCT.md, DESIGN.md, docs/ui-brief.md, .impeccable/surfaces/lib-main-dart.md, docs/testing.md, seed-output.txt, primary Flutter screens/theme/widgets/controller, widget regression assertions, craft-floor.md, and android.md. The user reference is references/images/Gemini_Generated_Image_h7fhevh7fhevh7fh.jpeg. The code-led build has no approved comp. No chosen-world QUALITY BAR card was supplied.

Native PNGs opened: welcome-phone.png, quiz-phone.png, quiz-landscape-dark.png, quiz-font-large-dark.png, result-phone.png, result-phone-dark.png, review-phone-dark.png, result-tablet-dark.png, welcome-reset-phone.png, welcome-keyboard-phone.png. All same-name JSON files were read. Final reset/keyboard replacements were opened only after READY. session.json records source b2356bb, final APK hash, score 80, reset checks, D caches/temp, and restored device settings.

Supplementary renderer PNGs opened separately under docs/screenshots: welcome-phone.png, welcome-wide.png, quiz-phone.png, quiz-landscape-dark.png, result-phone.png, result-phone-dark.png, review-phone.png. They are Flutter test renders, not emulator evidence.

Native evidence is API 35 on Pixel_8_2, 1080×2400 at density 420. Landscape is 2400×1080; enlarged font scale is 1.3. Tablet evidence is a 1600×2560/density-320 emulator override, not physical-tablet performance.

- App-owned QuizController keeps answers outside individual routes/layouts. Source and supplied tests corroborate retention through rotation, navigation, and theme changes.
- Four shared OptionCard instances use semantic selected state and Material Icons alongside color. No glyph/emoji substitutes, decorative glass, gradient text, or hard-offset shadows were found.
- ThemeData enables Material 3, bundles Nunito, and maps semantic light/dark roles. Controls have sufficient touch dimensions. SafeArea and Scaffold resizing keep system bars and IME outside the content viewport.
- Quiz PopScope maps Android Back to the previous question and permits leaving the first question. This does not establish exhaustive physical-device predictive-Back verification.
- Landscape is intentionally scrollable. The top capture shows upper options while the action footer remains visible; this documented height adaptation is not missing option content.
- Result shows controller-derived name, score, and correct/incorrect counts. Yellow score and glossy trophy preserve the requested emphasis without invented leaderboard data.
- Welcome validates at submit and resets form/submission state after replay. Replacement reset capture has no stale error or resume control. Keyboard capture keeps the entered name visible; native Done can submit through onFieldSubmitted.
- The two replacement captures show a thin green outer edge absent from prior captures and source. Its cause is unverified. It does not cover the app or invalidate reset/IME evidence and is not an app design token.

Flat native ground pixel samples: #FAF8FF in Welcome/light Result; #121529 in dark Quiz/Result. Source-token contrast: muted light text/canvas 5.61:1; ink/yellow CTA 11.50:1; white/purple 6.03:1; large yellow score/purple 4.08:1; muted dark text/navy 10.25:1; muted dark text/dark surface 9.09:1; ink/selected lavender 7.89:1.

No material source/design fixes are required by this review. Disposition: ship at the supplied Android emulator/debug scope. Physical-device testing and release signing are not claimed.
