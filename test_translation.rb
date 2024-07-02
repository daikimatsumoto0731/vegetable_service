# frozen_string_literal: true

# test_translation.rb

require_relative 'lib/libre_translate' # libディレクトリのlibre_translate.rbを読み込む

# テスト用のテキスト
text = 'Hello, world!'

# 翻訳を実行
translated_text = LibreTranslate.translate(text, 'en', 'ja')

# 結果を表示
puts "Original: #{text}"
puts "Translated: #{translated_text}"
