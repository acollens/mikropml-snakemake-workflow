
rule combine_results:
    input:
        csv=expand(
            "results/{params}/{{type}}.csv",
            params=paramspace.instance_patterns
        ),
    output:
        csv="results/{type}-results.csv",
    log:
        "log/combine_results_{type}.txt",
    benchmark:
        "benchmarks/combine_results_{type}.txt"
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_results.R"


rule combine_hp_performance:
    input:
        rds=expand(f"results/{paramspace_tame_seed}/model.Rds", seed=seeds),
    output:
        rds="results/ml_methods-{ml_methods}/hp_performance_results.Rds",
    log:
        "log/ml_methods-{ml_methods}/combine_hp_perf.txt",
    benchmark:
        "benchmarks/ml_methods-{ml_methods}/combine_hp_perf.txt"
    resources:
        mem_mb=MEM_PER_GB * 16,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_hp_perf.R"


rule mutate_benchmark:
    input:
        tsv=f"benchmarks/{paramspace.wildcard_pattern}/run_ml.txt",
    output:
        csv=f"results/{paramspace.wildcard_pattern}/benchmarks.csv",
    log:
        f"log/{paramspace.wildcard_pattern}/mutate_benchmark.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/mutate_benchmark.R"
