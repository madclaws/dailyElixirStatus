# Publisher will submit the solution to exercism and to github.
param ([string]$sol_file_dir, [string]$sol_folder_dir, [string]$commit)

exercism submit $sol_file_dir
Copy-Item "D:\Lab\Exercism\elixir\" + $sol_folder_dir + "\" D:\Lab\Elixir\dailyElixirStatus\ -Recurse
Set-Location D:\Lab\Elixir\dailyElixirStatus
git add .
git commit -m $commit
git push

