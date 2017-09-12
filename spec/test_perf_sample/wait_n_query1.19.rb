describe 'WideWorldImporters: slow test query simulation' do

    it 'waits and executes a query on a column without index' do
        expect(sql.WideWorldImporters.test_perf_samples.wait_n_query.count).to be > 0
    end
end