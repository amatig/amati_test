// look
-                               for (var z = 0; z < that.prices.length; z++) {
-                                       var temp_store = tab1.data[0].rows[e.index].children[0].children[1].store;
-                                       if (temp_store) {
-                                               //App.Module.log.error('=====>>>> ' + JSON.stringify(temp_store));
-                                               var price_store = App.Module.dataManager.getPrice(that.prices[z].materiale, temp_store.org_comm, temp_store.mercato, temp_store.tipo_cliente, temp_store.valuta);
-                                               //App.Module.log.error('=====>>>> ' + price_store.valuta + ' ' + price_store.prezzo);
-                                               that.prices[z].text = price_store.valuta + ' ' + price_store.prezzo;
-                                       } else
-                                               that.prices[z].text = '';