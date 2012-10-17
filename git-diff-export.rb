#!/usr/bin/ruby -Ku

require 'fileutils'

# つかいかた
if ARGV.length == 0
  print "[Usage?] % git_diff_export [from revesion] [export dirpath]\n"
  exit(false)
end

# 引数が足りないよ
if ARGV.length != 2
  print "[Error!] An insufficient number of arguments."
  exit(false)
end

# 引数をとるよ
rev = ARGV[0]
dir = ARGV[1]

# エクスポート先が確保できないよ
if !File::exist?(dir) && !FileUtils.mkdir_p(dir, :mode => 0755)
  print "[Error!] Specified dirname is not exists & cannot mkdir.\n"
  exit(false)
end

# おしりにスラッシュ
if !dir.match(/\/$/)
  dir += '/'
end

# git diffを実行
print "[ exec ] git diff --name-status #{rev}..\n"
lines = `git diff --name-status #{rev}..`

# 削除リスト
killnote = []

# 1行ずつ処理
lines.each_line do |line|

  line    = line.sub(/\n$/, '')
  status  = line.slice!(/^[ADM]{1}\s+/).sub(/\s+/, '')

  # D のとき
  if status == 'D'
    killnote.push(line)
  # A, M のとき
  else
    from    = line.sub(/\n$/, '')
    to      = dir+from
    dirname = File::dirname(to)

    # すでに存在するディレクトリは無視
    if File::exist?(dirname)
      #print "[notice] This dir(#{dirname}) was already created.\n"
    # いずれにも該当しなければ作成
    else
      print "[ mkdir] #{dirname}\n"
      FileUtils.mkdir_p(dirname)
    end

    # ファイルをコピー
    if File::exist?(from)
      print "[ copy ] #{from} => #{to}\n"
      FileUtils.cp(from, to)
    end

  end

end

# デスノート ...〆(.. )
if killnote != []
  print "[remove] Please check '__REMOVE_US__.txt' and delete them.\n"
  F = open(dir+'__REMOVE_US__.txt', 'w') do |f|
    f.puts killnote.join("\n")
  end
end
