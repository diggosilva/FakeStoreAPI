//
//  ViewController.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 24/01/26.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    private let contentView = FeedView()
    private let viewModel: any FeedViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(service: ServiceProtocol = Service()) {
        self.viewModel = FeedViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSourcesAndDelegates()
        handleStates()
        fetchProducts()
    }
    
    private func configureNavigationBar() {
        searchController.searchBar.placeholder = "Buscar produto"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Fake Store - Produtos"
        
        definesPresentationContext = true
    }
    
    private func configureDataSourcesAndDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle: break
                case .loading: showLoadingState()
                case .loaded: showLoadedState()
                case .error(let error): showErrorState(message: error)
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        contentView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        contentView.spinner.stopAnimating()
        contentView.tableView.reloadData()
    }
    
    private func showErrorState(message: String) {
        showErrorAlert(message: message)
    }
    
    private func fetchProducts() {
        Task { await viewModel.fetchProducts() }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UITableViewCell() }
        let product = viewModel.productForRow(at: indexPath.row)
        cell.configure(with: product)
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = viewModel.productForRow(at: indexPath.row)
        let viewModel = ProductDetailViewModel(product: product)
        let detailsVC = ProductDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.search(text: text)
        contentView.tableView.reloadData()
        setNeedsUpdateContentUnavailableConfiguration()
    }
}

extension FeedViewController {
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        switch viewModel.currentState {
        case .idle, .loading:
            contentUnavailableConfiguration = nil
            return
        default:
            break
        }
        
        if viewModel.numberOfRows() == 0 {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(systemName: "exclamationmark.magnifyingglass")
            config.text = "Nenhum produto encontrado."
            
            let searchText = searchController.searchBar.text ?? ""
            
            if searchText.isEmpty {
                config.secondaryText = "Use a busca para encontrar um produto."
            } else {
                config.secondaryText = "Nenhum produto encontrado com o termo '\(searchText)'"
            }
            self.contentUnavailableConfiguration = config
        } else {
            self.contentUnavailableConfiguration = nil
        }
    }
}
