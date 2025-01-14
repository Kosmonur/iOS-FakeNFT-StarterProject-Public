//
//  CartViewController+UITableViewDataSource.swift
//  FakeNFT
//
//  Created by Vitaly on 09.10.2023.
//

import Foundation
import UIKit

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.order.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = self.cartTable.dequeueReusableCell()
        cell.delegate = self
        guard let viewModel = viewModel else {
            return cell
        }
        cell.setup(nfs: viewModel.order[indexPath.row])
        return cell
    }
}


