function Fetch {
    param (
        [string]$Path
    )

    $pathName = (Split-Path -Leaf $Path).Replace("task-", "")
    $destPath = Join-Path -Path "C:\Users\ricar\A-Note\Trabalho\misc-masters" -ChildPath $pathName

    Copy-Item -Path $Path -Destination $destPath -Recurse -Force

    # List of unwanted (direct) files and directories
    $unwantedItems = @(".git", ".Rproj.user", ".RData", ".Rhistory", "latex_build/", "personal/")
    foreach ($item in $unwantedItems) {
        $fullPath = Join-Path -Path $destPath -ChildPath $item
        if (Test-Path $fullPath) {
            Remove-Item -Path $fullPath -Recurse -Force
        }
    }

    Write-Output "Copied $pathName to `"$destPath`""
}

$paths = @(
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\1T-Econometrics 1\task-econometrics1",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\2T-Econometrics 2\task-econometrics2",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\3T-Forecasting\task-forecasting",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\3T-Macroeconomics 3\task-quant-macro",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\3T-Microeconometrics 1\task-microeconometrics1",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\4T-Heterogeneity in macroeconomics\task-heterogeneous-macro",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\4T-Monetary policy models\task-monetary-policy",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\5T-Bayesian econometrics\task-bayesian-econometrics",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\5T-Computational methods in economics\task-comp-econ",
    "C:\Users\ricar\OneDrive\A-Estudo\Mestrado\5T-Statistical learning\task-statistical-learning"
)

foreach ($path in $paths) {
    Fetch $path
}
